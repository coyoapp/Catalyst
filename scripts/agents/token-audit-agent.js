#!/usr/bin/env node
/**
 * token-audit-agent.js
 *
 * Reads the component spec (spec.md) and all token files in /tokens/src/,
 * then produces a token-audit.md report showing which tokens are available,
 * which are missing, and naming suggestions for missing ones.
 *
 * NEVER writes to /tokens/src/ — the design team owns that source.
 *
 * Usage:
 *   node token-audit-agent.js --component=badge
 *   node token-audit-agent.js --component=badge --spec=path/to/custom-spec.md
 */

import { program } from 'commander';
import chalk from 'chalk';
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';
import {
  parseSpecContract,
  collectContractTokenRequirements,
  isSentinelTokenValue,
  normalizeTokenValue,
} from './spec-contract.js';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const REPO_ROOT = path.resolve(__dirname, '..', '..');
const TOKENS_SRC = path.join(REPO_ROOT, 'tokens', 'src');
const OUTPUT_DIR = path.join(__dirname, 'output');

// ---------------------------------------------------------------------------
// CLI
// ---------------------------------------------------------------------------

program
  .requiredOption('--component <name>', 'Component name in kebab-case (e.g. badge, text-input)')
  .option('--spec <path>', 'Path to spec.md (defaults to output/<component>/spec.md)')
  .parse(process.argv);

const opts = program.opts();
const componentName = opts.component.toLowerCase();
const componentOutputDir = path.join(OUTPUT_DIR, componentName);
const specPath = opts.spec ?? path.join(componentOutputDir, 'spec.md');
const auditOutputPath = path.join(componentOutputDir, 'token-audit.md');

// ---------------------------------------------------------------------------
// Token loader
// ---------------------------------------------------------------------------

/**
 * Recursively loads all .json files from a directory and merges them into
 * a flat map of token paths → token objects.
 * e.g. { "color.theme.primary.bg": { value: "#...", type: "color" } }
 */
function loadAllTokens(dir) {
  const tokens = {};

  function walk(currentDir, pathPrefix) {
    const entries = fs.readdirSync(currentDir, { withFileTypes: true });
    for (const entry of entries) {
      if (entry.isDirectory()) {
        walk(path.join(currentDir, entry.name), pathPrefix);
      } else if (entry.name.endsWith('.json')) {
        const raw = JSON.parse(fs.readFileSync(path.join(currentDir, entry.name), 'utf8'));
        flattenTokens(raw, [], tokens);
      }
    }
  }

  function flattenTokens(obj, currentPath, result) {
    for (const [key, value] of Object.entries(obj)) {
      const newPath = [...currentPath, key];
      if (value && typeof value === 'object' && 'value' in value) {
        result[newPath.join('.')] = value;
      } else if (value && typeof value === 'object') {
        flattenTokens(value, newPath, result);
      }
    }
  }

  walk(dir, []);
  return tokens;
}

// ---------------------------------------------------------------------------
// Spec parser
// ---------------------------------------------------------------------------

/**
 * Parses a spec.md file looking for token requirement blocks.
 *
 * The agent looks for markdown tables with the header pattern:
 *   | Property | Token Path | Notes |
 * or any table that appears under a "## Token" heading.
 *
 * Also extracts a plain list of token paths mentioned anywhere in the spec
 * as inline code like `color.theme.primary.bg`.
 */
function parseSpecForTokens(specContent) {
  const requirements = [];

  // 1. Extract token paths from inline code blocks  `path.to.token`
  const inlineCodeRe = /`([a-z][a-z0-9.-]+\.[a-z][a-z0-9.-]+)`/g;
  let match;
  while ((match = inlineCodeRe.exec(specContent)) !== null) {
    const candidate = normalizeTokenValue(match[1]);
    // Filter to values that look like token paths (at least 2 segments)
    if (candidate.split('.').length >= 2 && !isSentinelTokenValue(candidate)) {
      requirements.push({
        source: 'inline-code',
        path: candidate,
        property: candidate,
        notes: '',
      });
    }
  }

  // 2. Extract rows from markdown tables that have a "token" column
  const tableRe = /\|([^\n]+)\|\n\|[-| :]+\|\n((?:\|[^\n]+\|\n?)+)/g;
  while ((match = tableRe.exec(specContent)) !== null) {
    const headers = match[1].split('|').map(h => h.trim().toLowerCase());
    const tokenColIdx = headers.findIndex(h => h.includes('token'));
    const propertyColIdx = headers.findIndex(h =>
      h.includes('property') || h.includes('role') || h.includes('usage')
    );
    const notesColIdx = headers.findIndex(h => h.includes('note'));

    if (tokenColIdx === -1) continue;

    const rows = match[2].trim().split('\n');
    for (const row of rows) {
      const cols = row.split('|').map(c => c.trim()).filter(Boolean);
      const tokenPath = normalizeTokenValue(cols[tokenColIdx]?.replace(/`/g, '').trim());
      if (!tokenPath || tokenPath === '-' || isSentinelTokenValue(tokenPath)) continue;

      requirements.push({
        source: 'table',
        path: tokenPath,
        property: cols[propertyColIdx] ?? tokenPath,
        notes: cols[notesColIdx] ?? '',
      });
    }
  }

  // Deduplicate by path
  const seen = new Set();
  return requirements.filter(r => {
    if (seen.has(r.path)) return false;
    seen.add(r.path);
    return true;
  });
}

function combineRequirements(legacyRequirements, contractRequirements) {
  const seen = new Set();
  const merged = [...contractRequirements, ...legacyRequirements];
  return merged.filter(req => {
    if (seen.has(req.path)) return false;
    seen.add(req.path);
    return true;
  });
}

// ---------------------------------------------------------------------------
// Audit logic
// ---------------------------------------------------------------------------

/**
 * Checks each required token against the loaded token map.
 * Returns structured audit results.
 */
function auditTokens(requirements, allTokens) {
  return requirements.map(req => {
    const exactMatch = allTokens[req.path];
    if (exactMatch) {
      return { ...req, status: 'exists', matchedPath: req.path, value: exactMatch.value, type: exactMatch.type };
    }

    // Fuzzy: look for a token path that ends with the last 2 segments
    const segments = req.path.split('.');
    const suffix = segments.slice(-2).join('.');
    const fuzzyMatches = Object.keys(allTokens).filter(k => k.endsWith(suffix));
    if (fuzzyMatches.length === 1) {
      return {
        ...req,
        status: 'fuzzy-match',
        matchedPath: fuzzyMatches[0],
        value: allTokens[fuzzyMatches[0]].value,
        type: allTokens[fuzzyMatches[0]].type,
        note: `Spec path "${req.path}" not found; closest match: "${fuzzyMatches[0]}"`,
      };
    }
    if (fuzzyMatches.length > 1) {
      return {
        ...req,
        status: 'ambiguous',
        matchedPath: null,
        candidates: fuzzyMatches,
        note: `Multiple tokens match suffix "${suffix}": ${fuzzyMatches.join(', ')}`,
      };
    }

    return { ...req, status: 'missing', matchedPath: null };
  });
}

/**
 * Suggests a W3C-format token path for a missing token
 * based on naming conventions in the existing token files.
 */
function suggestTokenPath(req) {
  // If the spec already provided a well-formed path, keep it
  if (req.path.split('.').length >= 3) return req.path;
  // Otherwise suggest a component-scoped path
  return `component.${componentName}.${req.property.toLowerCase().replace(/\s+/g, '-')}`;
}

// ---------------------------------------------------------------------------
// Report generator
// ---------------------------------------------------------------------------

function buildReport(auditResults, allTokens, specContent) {
  const exists = auditResults.filter(r => r.status === 'exists');
  const fuzzy = auditResults.filter(r => r.status === 'fuzzy-match');
  const ambiguous = auditResults.filter(r => r.status === 'ambiguous');
  const missing = auditResults.filter(r => r.status === 'missing');

  const date = new Date().toISOString().split('T')[0];
  const totalTokenCount = Object.keys(allTokens).length;

  let md = `# Token Audit — ${componentName}\n`;
  md += `\nGenerated: ${date}  \n`;
  md += `Token source: \`tokens/src/\` (${totalTokenCount} tokens loaded)  \n`;
  md += `Spec: \`${specPath}\`\n`;

  md += `\n---\n\n## Summary\n\n`;
  md += `| Status | Count |\n|---|---|\n`;
  md += `| ✅ Exists | ${exists.length} |\n`;
  md += `| ⚠️ Fuzzy match (path differs) | ${fuzzy.length} |\n`;
  md += `| ❓ Ambiguous (multiple candidates) | ${ambiguous.length} |\n`;
  md += `| ❌ Missing | ${missing.length} |\n`;

  if (exists.length > 0) {
    md += `\n---\n\n## ✅ Existing Tokens\n\n`;
    md += `These tokens are referenced in the spec and confirmed present in \`tokens/src/\`.\n\n`;
    md += `| Property | Token Path | Type | Value |\n|---|---|---|---|\n`;
    for (const r of exists) {
      md += `| ${r.property} | \`${r.matchedPath}\` | ${r.type ?? '-'} | \`${r.value}\` |\n`;
    }
  }

  if (fuzzy.length > 0) {
    md += `\n---\n\n## ⚠️ Fuzzy Matches\n\n`;
    md += `The spec references these paths but the exact path was not found. A close match was identified — verify it is the correct token.\n\n`;
    md += `| Property | Spec Path | Closest Match | Value |\n|---|---|---|---|\n`;
    for (const r of fuzzy) {
      md += `| ${r.property} | \`${r.path}\` | \`${r.matchedPath}\` | \`${r.value}\` |\n`;
    }
  }

  if (ambiguous.length > 0) {
    md += `\n---\n\n## ❓ Ambiguous Tokens\n\n`;
    md += `Multiple tokens matched the suffix for these paths. Clarify which is correct.\n\n`;
    for (const r of ambiguous) {
      md += `**${r.property}** (\`${r.path}\`)  \nCandidates:\n`;
      for (const c of r.candidates ?? []) {
        md += `- \`${c}\` → \`${allTokens[c]?.value}\`\n`;
      }
      md += `\n`;
    }
  }

  if (missing.length > 0) {
    md += `\n---\n\n## ❌ Missing Tokens\n\n`;
    md += `These tokens are required by the spec but do not exist in \`tokens/src/\`.\n\n`;
    md += `**Do NOT add these manually.** Share this section with the design team — tokens are provided from Figma.\n\n`;
    md += `| Property | Spec Path | Suggested W3C Path | Notes |\n|---|---|---|---|\n`;
    for (const r of missing) {
      const suggested = suggestTokenPath(r);
      md += `| ${r.property} | \`${r.path}\` | \`${suggested}\` | ${r.notes || 'Request from design team'} |\n`;
    }
  }

  md += `\n---\n\n## Available Token Namespaces\n\n`;
  md += `These namespaces exist in \`tokens/src/\` and may be useful for this component:\n\n`;

  // Collect top-level namespaces
  const namespaces = {};
  for (const key of Object.keys(allTokens)) {
    const top = key.split('.').slice(0, 3).join('.');
    namespaces[top] = (namespaces[top] ?? 0) + 1;
  }
  const sorted = Object.entries(namespaces).sort((a, b) => b[1] - a[1]);
  for (const [ns, count] of sorted.slice(0, 20)) {
    md += `- \`${ns}.*\` (${count} tokens)\n`;
  }

  md += `\n---\n\n## Next Step\n\n`;
  if (missing.length > 0) {
    md += `There are **${missing.length} missing token(s)**. Before scaffolding:\n\n`;
    md += `1. Share the ❌ Missing Tokens table above with the design team\n`;
    md += `2. Wait for tokens to be added to Figma and synced into \`tokens/src/\`\n`;
    md += `3. Re-run the audit: \`node token-audit-agent.js --component=${componentName}\`\n`;
    md += `4. Once all tokens show ✅, proceed to scaffold:\n`;
    md += `   \`node scaffold-agent.js --component=${componentName}\`\n`;
  } else {
    md += `All required tokens are present. You can now scaffold the component:\n\n`;
    md += `\`\`\`bash\nnode scaffold-agent.js --component=${componentName}\n\`\`\`\n`;
  }

  return md;
}

// ---------------------------------------------------------------------------
// Main
// ---------------------------------------------------------------------------

async function main() {
  console.log(chalk.bold.cyan(`\nCatalyst Token Audit Agent`));
  console.log(chalk.dim(`Component: ${componentName}\n`));

  // Load tokens
  console.log(chalk.dim(`Loading tokens from ${TOKENS_SRC}...`));
  const allTokens = loadAllTokens(TOKENS_SRC);
  console.log(chalk.green(`  Loaded ${Object.keys(allTokens).length} tokens`));

  // Load spec
  if (!fs.existsSync(specPath)) {
    console.log(chalk.yellow(`\nNo spec.md found at: ${specPath}`));
    console.log(chalk.dim(`Options:`));
    console.log(chalk.dim(`  1. Run research-agent first: node research-agent.js --component=${componentName}`));
    console.log(chalk.dim(`  2. Create the spec manually at: ${specPath}`));
    console.log(chalk.dim(`  3. Point to an existing spec: --spec=path/to/spec.md`));
    console.log(chalk.dim(`\nRunning in token-inventory-only mode — listing available tokens...\n`));

    fs.mkdirSync(componentOutputDir, { recursive: true });
    const inventoryReport = buildTokenInventoryReport(allTokens);
    fs.writeFileSync(auditOutputPath, inventoryReport);
    console.log(chalk.green(`\nToken inventory written to: ${auditOutputPath}`));
    return;
  }

  console.log(chalk.dim(`Parsing spec from ${specPath}...`));
  const specContent = fs.readFileSync(specPath, 'utf8');
  const legacyRequirements = parseSpecForTokens(specContent);
  const contract = parseSpecContract(specContent);
  const contractRequirements = contract ? collectContractTokenRequirements(contract) : [];
  const requirements = combineRequirements(legacyRequirements, contractRequirements);
  console.log(chalk.green(`  Found ${requirements.length} token requirements in spec`));

  if (requirements.length === 0) {
    console.log(chalk.yellow(`\nNo token paths found in spec.md.`));
    console.log(chalk.dim(`Make sure your spec includes token paths as inline code or in tables.`));
    console.log(chalk.dim(`Example: "Background uses \`color.theme.primary.bg\`"`));
  }

  // Audit
  console.log(chalk.dim(`\nAuditing tokens...`));
  const auditResults = auditTokens(requirements, allTokens);

  const exists = auditResults.filter(r => r.status === 'exists').length;
  const missing = auditResults.filter(r => r.status === 'missing').length;
  const fuzzy = auditResults.filter(r => r.status === 'fuzzy-match').length;

  console.log(chalk.green(`  ✅ Exists: ${exists}`));
  if (fuzzy > 0) console.log(chalk.yellow(`  ⚠️  Fuzzy matches: ${fuzzy}`));
  if (missing > 0) console.log(chalk.red(`  ❌ Missing: ${missing}`));

  // Write report
  fs.mkdirSync(componentOutputDir, { recursive: true });
  const report = buildReport(auditResults, allTokens, specContent);
  fs.writeFileSync(auditOutputPath, report);

  console.log(chalk.bold.green(`\nAudit report written to:`));
  console.log(chalk.cyan(`  ${auditOutputPath}`));

  if (missing > 0) {
    console.log(chalk.yellow(`\n${missing} missing token(s). Share the report with the design team before proceeding.`));
  } else {
    console.log(chalk.green(`\nAll tokens present. Ready to scaffold:`));
    console.log(chalk.dim(`  node scaffold-agent.js --component=${componentName}`));
  }
}

function buildTokenInventoryReport(allTokens) {
  const date = new Date().toISOString().split('T')[0];
  let md = `# Token Inventory — ${componentName}\n\n`;
  md += `Generated: ${date} (no spec.md found — showing full token inventory)\n\n---\n\n`;
  md += `## All Available Token Namespaces\n\n`;

  const groups = {};
  for (const [key, token] of Object.entries(allTokens)) {
    const group = key.split('.').slice(0, 2).join('.');
    if (!groups[group]) groups[group] = [];
    groups[group].push({ key, ...token });
  }

  for (const [group, tokens] of Object.entries(groups)) {
    md += `### \`${group}\`\n\n`;
    md += `| Token | Type | Value |\n|---|---|---|\n`;
    for (const t of tokens.slice(0, 30)) {
      md += `| \`${t.key}\` | ${t.type ?? '-'} | \`${t.value}\` |\n`;
    }
    if (tokens.length > 30) md += `| ... | | (${tokens.length - 30} more) |\n`;
    md += `\n`;
  }

  return md;
}

main().catch(err => {
  console.error(chalk.red(`\nError: ${err.message}`));
  process.exit(1);
});
