/**
 * token-auditor.js
 *
 * Cross-references token requirements from the decisions object against
 * the token source files in tokens/src/.
 *
 * Pure function (given the tokens dir path) — no LLM, no side effects beyond reading files.
 *
 * Usage (from agent):
 *   import { auditTokens, loadAllTokens } from '../tools/token-auditor.js';
 *   const allTokens = loadAllTokens(tokensSrcPath);
 *   const result = auditTokens(tokenRequirements, allTokens);
 */

import fs from 'fs';
import path from 'path';

/**
 * Recursively loads all .json files from a directory and merges them into
 * a flat map of token paths → token objects.
 * e.g. { "color.theme.primary.bg": { value: "#...", type: "color" } }
 *
 * @param {string} dir - Path to tokens/src/
 * @returns {Record<string, { value: string, type: string }>}
 */
function loadAllTokens(dir) {
  const tokens = {};

  function flattenTokens(obj, currentPath) {
    for (const [key, value] of Object.entries(obj)) {
      const newPath = [...currentPath, key];
      if (value && typeof value === 'object' && 'value' in value) {
        tokens[newPath.join('.')] = value;
      } else if (value && typeof value === 'object') {
        flattenTokens(value, newPath);
      }
    }
  }

  function walk(currentDir) {
    const entries = fs.readdirSync(currentDir, { withFileTypes: true });
    for (const entry of entries) {
      const fullPath = path.join(currentDir, entry.name);
      if (entry.isDirectory()) {
        walk(fullPath);
      } else if (entry.name.endsWith('.json')) {
        try {
          const raw = JSON.parse(fs.readFileSync(fullPath, 'utf8'));
          flattenTokens(raw, []);
        } catch {
          // Skip malformed JSON files silently
        }
      }
    }
  }

  walk(dir);
  return tokens;
}

/**
 * Audits an array of token requirements against a loaded token map.
 *
 * Each requirement is: { property: string, tokenPath: string }
 *
 * Returns:
 *   resolved  — exact match found
 *   fuzzy     — close match found (last 2 segments matched)
 *   ambiguous — multiple candidates for the suffix
 *   missing   — no match found
 *
 * @param {Array<{ property: string, tokenPath: string }>} requirements
 * @param {Record<string, { value: string, type: string }>} allTokens
 * @returns {{ resolved: any[], fuzzy: any[], ambiguous: any[], missing: any[] }}
 */
function auditTokens(requirements, allTokens) {
  const resolved = [];
  const fuzzy = [];
  const ambiguous = [];
  const missing = [];

  for (const req of requirements) {
    const { property, tokenPath } = req;
    if (!tokenPath || tokenPath === '-' || tokenPath === 'none') continue;

    const exactMatch = allTokens[tokenPath];
    if (exactMatch) {
      resolved.push({ property, tokenPath, value: exactMatch.value, type: exactMatch.type });
      continue;
    }

    // Fuzzy: match on last 2 segments
    const segments = tokenPath.split('.');
    const suffix = segments.slice(-2).join('.');
    const fuzzyMatches = Object.keys(allTokens).filter(k => k.endsWith(suffix));

    if (fuzzyMatches.length === 1) {
      fuzzy.push({
        property,
        specPath: tokenPath,
        matchedPath: fuzzyMatches[0],
        value: allTokens[fuzzyMatches[0]].value,
        type: allTokens[fuzzyMatches[0]].type,
      });
    } else if (fuzzyMatches.length > 1) {
      ambiguous.push({
        property,
        specPath: tokenPath,
        candidates: fuzzyMatches.map(k => ({ path: k, value: allTokens[k].value })),
      });
    } else {
      missing.push({ property, tokenPath });
    }
  }

  return { resolved, fuzzy, ambiguous, missing };
}

/**
 * Formats the audit result as a markdown report section.
 *
 * @param {{ resolved, fuzzy, ambiguous, missing }} auditResult
 * @param {string} componentName
 * @returns {string}
 */
function formatAuditReport(auditResult, componentName) {
  const { resolved, fuzzy, ambiguous, missing } = auditResult;
  const date = new Date().toISOString().split('T')[0];

  let md = `# Token Audit — ${componentName}\n\nGenerated: ${date}\n\n`;
  md += `## Summary\n\n`;
  md += `| Status | Count |\n|---|---|\n`;
  md += `| ✅ Resolved | ${resolved.length} |\n`;
  md += `| ⚠️ Fuzzy match | ${fuzzy.length} |\n`;
  md += `| ❓ Ambiguous | ${ambiguous.length} |\n`;
  md += `| ❌ Missing | ${missing.length} |\n\n`;

  if (resolved.length > 0) {
    md += `## ✅ Resolved Tokens\n\n`;
    md += `| Property | Token Path | Type | Value |\n|---|---|---|---|\n`;
    for (const r of resolved) {
      md += `| ${r.property} | \`${r.tokenPath}\` | ${r.type ?? '-'} | \`${r.value}\` |\n`;
    }
    md += '\n';
  }

  if (fuzzy.length > 0) {
    md += `## ⚠️ Fuzzy Matches\n\nVerify these are the correct tokens before proceeding.\n\n`;
    md += `| Property | Spec Path | Closest Match | Value |\n|---|---|---|---|\n`;
    for (const r of fuzzy) {
      md += `| ${r.property} | \`${r.specPath}\` | \`${r.matchedPath}\` | \`${r.value}\` |\n`;
    }
    md += '\n';
  }

  if (ambiguous.length > 0) {
    md += `## ❓ Ambiguous Tokens\n\nMultiple tokens matched. Clarify which is intended.\n\n`;
    for (const r of ambiguous) {
      md += `**${r.property}** (\`${r.specPath}\`)\n`;
      for (const c of r.candidates) {
        md += `- \`${c.path}\` → \`${c.value}\`\n`;
      }
      md += '\n';
    }
  }

  if (missing.length > 0) {
    md += `## ❌ Missing Tokens\n\n`;
    md += `These tokens do not exist in \`tokens/src/\`. **Do not add them manually.**\n`;
    md += `Share this list with the design team — tokens must come from Figma.\n\n`;
    md += `| Property | Expected Token Path |\n|---|---|\n`;
    for (const r of missing) {
      md += `| ${r.property} | \`${r.tokenPath}\` |\n`;
    }
    md += '\n';
  }

  return md;
}

export { loadAllTokens, auditTokens, formatAuditReport };
