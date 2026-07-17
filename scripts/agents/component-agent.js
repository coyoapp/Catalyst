#!/usr/bin/env node
/**
 * component-agent.js
 *
 * Single entry point for scaffolding a new Catalyst component.
 *
 * Usage:
 *   node scripts/agents/component-agent.js --component=badge
 *   node scripts/agents/component-agent.js --component=badge --model=claude-sonnet-4-5
 *   node scripts/agents/component-agent.js --component=badge --skip-scaffold
 *
 * Before running:
 *   1. Create scripts/agents/output/{component}/brief.md describing the component
 *   2. Set GITHUB_TOKEN env var (GitHub PAT with Models: Read permission)
 *
 * Output (all files land in scripts/agents/output/{component}/):
 *   decisions.md     — agent reasoning + file plan + token requirements
 *   token-audit.md   — token cross-reference result
 *   review.md        — LLM review of generated files
 *   parity.md        — iOS ↔ Android alignment report
 *   Cat*.swift       — generated iOS source files
 *   Cat*.kt          — generated Android source files
 */

import { program } from 'commander';
import chalk from 'chalk';
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

import { validateDecisions } from '../tools/spec-validator.js';
import { loadAllTokens, auditTokens, formatAuditReport } from '../tools/token-auditor.js';
import { scaffold } from '../tools/scaffolder.js';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const REPO_ROOT = path.resolve(__dirname, '..', '..');
const TOKENS_SRC = path.join(REPO_ROOT, 'tokens', 'src');
const OUTPUT_DIR = path.join(__dirname, 'output');

// ---------------------------------------------------------------------------
// CLI
// ---------------------------------------------------------------------------

program
  .requiredOption('--component <name>', 'Component name in kebab-case (e.g. badge, text-input)')
  .option('--model <model>', 'LLM model to use (default: gpt-4o)', 'gpt-4o')
  .option('--skip-scaffold', 'Run LLM reasoning and review only — skip file generation', false)
  .parse(process.argv);

const opts = program.opts();
const componentName = opts.component.toLowerCase().replace(/\s+/g, '-');
const componentOutputDir = path.join(OUTPUT_DIR, componentName);
const briefPath = path.join(componentOutputDir, 'brief.md');

// ---------------------------------------------------------------------------
// LLM client
// ---------------------------------------------------------------------------

async function createLLMClient() {
  // Load .env if present
  const envPath = path.join(__dirname, '.env');
  if (fs.existsSync(envPath)) {
    for (const line of fs.readFileSync(envPath, 'utf8').split('\n')) {
      const [key, ...rest] = line.split('=');
      if (key?.trim() && rest.length) process.env[key.trim()] = rest.join('=').trim();
    }
  }

  const token = process.env.GITHUB_TOKEN;
  if (!token || token.startsWith('github_pat_') === false && !token.startsWith('ghp_') && token.length < 10) {
    throw new Error(
      'GITHUB_TOKEN not set or invalid.\n' +
      'Create a GitHub Personal Access Token with "Models: Read" permission.\n' +
      'Add it to scripts/agents/.env as GITHUB_TOKEN=ghp_...\n' +
      'Your GitHub Copilot subscription covers usage — no separate vendor account needed.'
    );
  }

  const { default: OpenAI } = await import('openai');
  const client = new OpenAI({
    baseURL: 'https://models.inference.ai.azure.com',
    apiKey: token,
  });

  return {
    model: opts.model,
    async complete(systemPrompt, userPrompt) {
      const response = await client.chat.completions.create({
        model: this.model,
        messages: [
          { role: 'system', content: systemPrompt },
          { role: 'user', content: userPrompt },
        ],
        max_tokens: 6000,
      });
      return response.choices[0]?.message?.content ?? '';
    },
  };
}

// ---------------------------------------------------------------------------
// Token vocabulary snapshot (sent to LLM for context)
// ---------------------------------------------------------------------------

function buildTokenVocabulary() {
  const allTokens = loadAllTokens(TOKENS_SRC);
  const vocab = { colors: [], spacing: [], sizes: [], borderRadius: [], borderWidth: [], typography: [] };

  for (const [key, token] of Object.entries(allTokens)) {
    const type = token.type ?? '';
    if (type === 'color' && (key.includes('theme') || key.includes('ui'))) vocab.colors.push(key);
    else if (type === 'spacing') vocab.spacing.push(key);
    else if (type === 'sizing') vocab.sizes.push(key);
    else if (type === 'borderRadius') vocab.borderRadius.push(key);
    else if (type === 'borderWidth') vocab.borderWidth.push(key);
    else if (type === 'typography') vocab.typography.push(key);
  }

  return { allTokens, vocab };
}

// ---------------------------------------------------------------------------
// Reference component loader (sent to LLM for pattern alignment)
// ---------------------------------------------------------------------------

function loadReferenceComponents() {
  const refs = [
    {
      label: 'iOS interactive reference: CatButtonStyle.swift',
      path: path.join(REPO_ROOT, 'iOS/Catalyst/Sources/Catalyst/Components/Buttons/CatButtonStyle.swift'),
    },
    {
      label: 'iOS interactive reference: CatButtonBuilder.swift',
      path: path.join(REPO_ROOT, 'iOS/Catalyst/Sources/Catalyst/Components/Buttons/CatButtonBuilder.swift'),
    },
    {
      label: 'iOS display reference: CatAlertStyle.swift',
      path: path.join(REPO_ROOT, 'iOS/Catalyst/Sources/Catalyst/Components/Alert/CatAlertStyle.swift'),
    },
    {
      label: 'iOS display reference: CatAlertBuilder.swift',
      path: path.join(REPO_ROOT, 'iOS/Catalyst/Sources/Catalyst/Components/Alert/CatAlertBuilder.swift'),
    },
    {
      label: 'Android interactive reference: CatButton.kt',
      path: path.join(REPO_ROOT, 'android/catalyst/src/main/java/com/haiilo/catalyst/components/buttons/CatButton.kt'),
    },
    {
      label: 'Android interactive reference: CatButtonEnums.kt',
      path: path.join(REPO_ROOT, 'android/catalyst/src/main/java/com/haiilo/catalyst/components/buttons/CatButtonEnums.kt'),
    },
    {
      label: 'Android interactive reference: CatButtonStateStyle.kt',
      path: path.join(REPO_ROOT, 'android/catalyst/src/main/java/com/haiilo/catalyst/components/buttons/CatButtonStateStyle.kt'),
    },
    {
      label: 'Android display reference: CatAlert.kt',
      path: path.join(REPO_ROOT, 'android/catalyst/src/main/java/com/haiilo/catalyst/components/alerts/CatAlert.kt'),
    },
    {
      label: 'Android display reference: CatAlertDefaults.kt',
      path: path.join(REPO_ROOT, 'android/catalyst/src/main/java/com/haiilo/catalyst/components/alerts/CatAlertDefaults.kt'),
    },
  ];

  return refs
    .filter(r => fs.existsSync(r.path))
    .map(r => `### ${r.label}\n\`\`\`\n${fs.readFileSync(r.path, 'utf8')}\n\`\`\``)
    .join('\n\n');
}

// ---------------------------------------------------------------------------
// Step 1: LLM — reason about the brief and produce decisions
// ---------------------------------------------------------------------------

async function reasonFromBrief(llm, briefContent, vocab) {
  const system = `You are a senior design system engineer for Catalyst Mobile Design System by Haiilo.
The system targets native iOS (SwiftUI) and Android (Jetpack Compose).
You produce concise, accurate component decisions from contributor briefs.
You must output valid JSON in the exact schema described. No markdown fences around the JSON — raw JSON only.`;

  const user = `## Contributor Brief
${briefContent}

## Your Task
Read the brief above and decide exactly what this component needs.
Apply these rules:
- Only add what the brief describes — no extra states, sizes, or variants "just in case"
- If the brief says the component is not tappable → profile must be "display"
- If it IS tappable → profile must be "interactive"
- "interactive" states must include: normal, pressed, focused, disabled
- "interactive" may include: hovered (iOS only), loading (only if brief mentions async)
- "display" states: normal + disabled only (unless brief explicitly says otherwise)
- hasSizes: true only if the brief mentions distinct size presets
- hasContentEnum: true only if there are 2+ structurally different content variations
- hasAccentPaletteSupport: true if the component has a "primary" or "brand" color variant

## Available Token Vocabulary (use these paths in tokenRequirements)
Colors (semantic): ${vocab.colors.slice(0, 50).join(', ')}
Spacing: ${vocab.spacing.join(', ')}
Sizes: ${vocab.sizes.join(', ')}
Border radius: ${vocab.borderRadius.join(', ')}
Border width: ${vocab.borderWidth.join(', ')}
Typography: ${vocab.typography.join(', ')}

## Android File Plan Rules
- interactive: always include Enums (if hasVariants or hasSizes or hasContentEnum), StateStyle, Defaults, Config, Composable
- display: include Colors, Defaults, Config, Composable; include Enums only if hasVariants
- Omit files that add no value for this specific component

## Required Output Schema (raw JSON, no markdown fences):
{
  "component": "<kebab-case name>",
  "profile": "interactive" | "display",
  "states": ["normal", ...],
  "hasVariants": true | false,
  "variants": ["Primary", "Danger", ...],
  "hasSizes": true | false,
  "sizes": [{ "name": "small", "heightToken": "size.2xl", "horizontalPaddingToken": "spacing.xl" }],
  "contentModel": "label" | "enum",
  "contentCases": ["TextOnly", "IconText", ...],
  "hasAccentPaletteSupport": true | false,
  "iosFilePlan": ["Style", "Builder", "Theme"],
  "androidFilePlan": ["Enums", "StateStyle", "Defaults", "Config", "Composable"],
  "tokenRequirements": [
    { "property": "primary background", "tokenPath": "color.theme.primary.bg" }
  ],
  "reasoning": "<2-4 sentences explaining key decisions>"
}`;

  const raw = await llm.complete(system, user);

  // Parse — strip any accidental markdown fences the LLM may add
  const cleaned = raw.replace(/^```(?:json)?\s*/i, '').replace(/\s*```$/i, '').trim();
  try {
    return JSON.parse(cleaned);
  } catch {
    throw new Error(`LLM returned invalid JSON for decisions.\n\nRaw output:\n${raw}`);
  }
}

// ---------------------------------------------------------------------------
// Step 2: Write decisions.md
// ---------------------------------------------------------------------------

function writeDecisions(decisions, auditResult, componentOutputDir) {
  const date = new Date().toISOString().split('T')[0];
  const { missing } = auditResult ?? { missing: [] };

  let md = `# Component Decisions — ${decisions.component}\n\nGenerated: ${date}\n\n`;
  md += `## Agent Reasoning\n\n${decisions.reasoning}\n\n`;
  md += `## Profile\n\n**${decisions.profile}** — `;
  md += decisions.profile === 'interactive'
    ? 'component responds to touch (press/focus states required)'
    : 'display only (no interaction states beyond disabled)';
  md += '\n\n';

  md += `## States\n\n${decisions.states.map(s => `- ${s}`).join('\n')}\n\n`;

  if (decisions.hasVariants) {
    md += `## Variants\n\n${decisions.variants.map(v => `- ${v}`).join('\n')}\n\n`;
  }

  if (decisions.hasSizes) {
    md += `## Sizes\n\n| Name | Height Token | H-Padding Token |\n|---|---|---|\n`;
    for (const s of decisions.sizes) {
      md += `| ${s.name} | \`${s.heightToken}\` | \`${s.horizontalPaddingToken ?? '-'}\` |\n`;
    }
    md += '\n';
  }

  md += `## Content Model\n\n**${decisions.contentModel}**`;
  if (decisions.contentModel === 'enum') {
    md += `\n\nContent cases:\n${decisions.contentCases.map(c => `- ${c}`).join('\n')}`;
  }
  md += '\n\n';

  md += `## Files to Generate\n\n### iOS\n${decisions.iosFilePlan.map(f => `- ${f}`).join('\n')}\n\n`;
  md += `### Android\n${decisions.androidFilePlan.map(f => `- ${f}`).join('\n')}\n\n`;

  md += `## Token Requirements\n\n| Property | Token Path |\n|---|---|\n`;
  for (const t of decisions.tokenRequirements ?? []) {
    md += `| ${t.property} | \`${t.tokenPath}\` |\n`;
  }
  md += '\n';

  if (missing?.length > 0) {
    md += `## ❌ Missing Tokens — Action Required\n\n`;
    md += `The following tokens are referenced but do not exist in \`tokens/src/\`.\n`;
    md += `**Do not add them manually.** Share this list with the design team — tokens must come from Figma.\n\n`;
    md += `| Property | Expected Token Path |\n|---|---|\n`;
    for (const m of missing) {
      md += `| ${m.property} | \`${m.tokenPath}\` |\n`;
    }
    md += `\n**To proceed:** update your brief.md with clarifications or wait for the design team to add the tokens, then re-run the agent.\n\n`;
  }

  md += `## Correcting Agent Decisions\n\n`;
  md += `If something above is wrong, you have two options:\n`;
  md += `1. **Edit brief.md** with more detail and re-run the agent\n`;
  md += `2. **Edit the generated files** directly in this output directory\n\n`;
  md += `Do not move files to source until review.md and parity.md show no blocking issues.\n`;

  fs.writeFileSync(path.join(componentOutputDir, 'decisions.md'), md, 'utf8');
}

// ---------------------------------------------------------------------------
// Step 3: LLM — review generated files
// ---------------------------------------------------------------------------

async function reviewGeneratedFiles(llm, decisions, writtenFiles, referenceComponents) {
  const fileContents = writtenFiles
    .map(f => `### ${path.basename(f)}\n\`\`\`\n${fs.readFileSync(f, 'utf8')}\n\`\`\``)
    .join('\n\n');

  const system = `You are a senior design system engineer reviewing generated Catalyst component files.
Be direct and specific. Flag real issues, not style preferences.`;

  const user = `## Generated Files for Review

${fileContents}

## Reference Components (gold standard patterns)

${referenceComponents}

## Review Checklist

Check each generated file against these rules and report any issues:

1. **Token usage** — no hardcoded hex values, all colors use CatColors.*, spacing uses CatSpacing.*, etc.
2. **Cat prefix** — all public types and files use the Cat prefix
3. **No reserved names** — no type named "Default" or similar reserved words  
4. **State priority** — disabled → loading (if applicable) → pressed → hovered (iOS only) → focused → normal
5. **Accessibility** — no hardcoded accessibilityLabel values; consuming view must set them
6. **Complexity** — nothing added beyond what the brief requires; no speculative parameters
7. **iOS pattern alignment** — matches CatButton (interactive) or CatAlert (display) pattern correctly
8. **Android pattern alignment** — matches CatButton.kt (interactive) or CatAlert.kt (display) pattern correctly
9. **Android token naming** — uses snake_case (border_radius_md not borderRadiusMd)
10. **No Material3 Surface** — Android composables use Box + clip + background directly

Format your response as markdown with a summary table followed by details for any issues found.
If everything looks good, say so clearly.`;

  return await llm.complete(system, user);
}

// ---------------------------------------------------------------------------
// Step 4: LLM — parity check iOS vs Android
// ---------------------------------------------------------------------------

async function checkParity(llm, decisions, writtenFiles) {
  const iosFiles = writtenFiles.filter(f => f.endsWith('.swift'));
  const androidFiles = writtenFiles.filter(f => f.endsWith('.kt'));

  if (iosFiles.length === 0 || androidFiles.length === 0) {
    return '# Parity Report\n\nSkipped — missing iOS or Android files.\n';
  }

  const iosContent = iosFiles
    .map(f => `### ${path.basename(f)}\n\`\`\`swift\n${fs.readFileSync(f, 'utf8')}\n\`\`\``)
    .join('\n\n');
  const androidContent = androidFiles
    .map(f => `### ${path.basename(f)}\n\`\`\`kotlin\n${fs.readFileSync(f, 'utf8')}\n\`\`\``)
    .join('\n\n');

  const system = `You are a senior cross-platform mobile engineer reviewing iOS and Android design system components for structural alignment.`;

  const user = `## iOS Files
${iosContent}

## Android Files
${androidContent}

## Parity Review

Compare the iOS and Android implementations and report on:

1. **Variant parity** — same variants on both platforms?
2. **State parity** — same states? (iOS may have hovered, Android should not)
3. **Content model parity** — same content options mapped to platform conventions?
4. **Token semantic parity** — same design intent? (naming conventions differ: Swift camelCase vs Kotlin snake_case)
5. **Config/environment parity** — both use composition-local / SwiftUI environment correctly?
6. **Missing coverage** — anything on iOS with no Android equivalent, or vice versa?

Output a markdown report with a summary table and specific findings.
Note: hovered state on iOS with no Android equivalent is expected and not an issue.`;

  return await llm.complete(system, user);
}

// ---------------------------------------------------------------------------
// Main
// ---------------------------------------------------------------------------

async function main() {
  console.log(chalk.bold.cyan('\n── Catalyst Component Agent ──\n'));
  console.log(chalk.dim(`Component: ${componentName}`));
  console.log(chalk.dim(`Model:     ${opts.model}\n`));

  // Guard: brief.md must exist
  if (!fs.existsSync(briefPath)) {
    console.error(chalk.red(`\nNo brief.md found at:\n  ${briefPath}\n`));
    console.error(chalk.bold('Create it first:'));
    console.error(chalk.dim(`  mkdir -p ${componentOutputDir}`));
    console.error(chalk.dim(`  # Then write a description of the component into brief.md`));
    process.exit(1);
  }

  fs.mkdirSync(componentOutputDir, { recursive: true });

  const briefContent = fs.readFileSync(briefPath, 'utf8').trim();
  if (briefContent.length < 30) {
    console.error(chalk.red('\nbriefContent is too short. Describe the component in plain English.\n'));
    process.exit(1);
  }

  // Connect to LLM
  console.log(chalk.dim('Connecting to LLM...'));
  let llm;
  try {
    llm = await createLLMClient();
    console.log(chalk.green(`  Using model: ${llm.model}`));
  } catch (err) {
    console.error(chalk.red(`\n${err.message}`));
    process.exit(1);
  }

  // Load tokens
  console.log(chalk.dim('\nLoading token vocabulary...'));
  const { allTokens, vocab } = buildTokenVocabulary();
  console.log(chalk.green(`  ${Object.keys(allTokens).length} tokens loaded`));

  // Load reference components
  console.log(chalk.dim('Loading reference components...'));
  const referenceComponents = loadReferenceComponents();

  // ── Step 1: Reason from brief ──────────────────────────────────────────
  console.log(chalk.bold.cyan('\n[1/4] Reasoning from brief...'));
  let decisions;
  try {
    decisions = await reasonFromBrief(llm, briefContent, vocab);
    decisions.component = componentName; // enforce kebab-case from CLI
  } catch (err) {
    console.error(chalk.red(`\nFailed to parse decisions: ${err.message}`));
    process.exit(1);
  }

  // Validate decisions
  const { valid, errors, warnings } = validateDecisions(decisions);
  if (warnings.length > 0) {
    for (const w of warnings) console.log(chalk.yellow(`  ⚠ ${w}`));
  }
  if (!valid) {
    console.error(chalk.red('\nDecisions failed validation:'));
    for (const e of errors) console.error(chalk.red(`  ✗ ${e}`));
    process.exit(1);
  }
  console.log(chalk.green(`  ✓ Profile: ${decisions.profile}`));
  console.log(chalk.green(`  ✓ States: ${decisions.states.join(', ')}`));
  console.log(chalk.green(`  ✓ iOS files: ${decisions.iosFilePlan.join(', ')}`));
  console.log(chalk.green(`  ✓ Android files: ${decisions.androidFilePlan.join(', ')}`));

  // ── Step 2: Token audit ────────────────────────────────────────────────
  console.log(chalk.bold.cyan('\n[2/4] Auditing tokens...'));
  const auditResult = auditTokens(decisions.tokenRequirements ?? [], allTokens);
  console.log(chalk.green(`  ✓ Resolved: ${auditResult.resolved.length}`));
  if (auditResult.fuzzy.length > 0) console.log(chalk.yellow(`  ⚠ Fuzzy: ${auditResult.fuzzy.length}`));
  if (auditResult.ambiguous.length > 0) console.log(chalk.yellow(`  ⚠ Ambiguous: ${auditResult.ambiguous.length}`));
  if (auditResult.missing.length > 0) console.log(chalk.red(`  ✗ Missing: ${auditResult.missing.length}`));

  // Write decisions.json — machine-readable, consumed by scaffolder CLI and OpenCode command
  fs.writeFileSync(
    path.join(componentOutputDir, 'decisions.json'),
    JSON.stringify(decisions, null, 2),
    'utf8'
  );

  // Write decisions.md — human-readable reasoning for contributor review
  writeDecisions(decisions, auditResult, componentOutputDir);
  console.log(chalk.dim(`  decisions.json + decisions.md written`));

  // Write token-audit.md
  const auditReport = formatAuditReport(auditResult, componentName);
  fs.writeFileSync(path.join(componentOutputDir, 'token-audit.md'), auditReport, 'utf8');
  console.log(chalk.dim(`  token-audit.md written`));

  // Halt on missing tokens
  if (auditResult.missing.length > 0) {
    console.error(chalk.bold.red(`\n── HALTED: ${auditResult.missing.length} missing token(s) ──\n`));
    console.error(chalk.yellow('The following tokens do not exist in tokens/src/:'));
    for (const m of auditResult.missing) {
      console.error(chalk.yellow(`  • ${m.property}: ${m.tokenPath}`));
    }
    console.error(chalk.bold('\nNext steps:'));
    console.error('  1. Check decisions.md for the full list');
    console.error('  2. Share missing tokens with the design team (tokens come from Figma)');
    console.error('  3. Update brief.md if a different token should be used instead');
    console.error('  4. Re-run once tokens are available in tokens/src/');
    process.exit(1);
  }

  // ── Step 3: Scaffold ───────────────────────────────────────────────────
  let writtenFiles = [];
  if (!opts.skipScaffold) {
    console.log(chalk.bold.cyan('\n[3/4] Scaffolding files...'));
    try {
      writtenFiles = await scaffold(decisions, componentOutputDir);
      for (const f of writtenFiles) {
        console.log(chalk.green(`  ✓ ${path.basename(f)}`));
      }
    } catch (err) {
      console.error(chalk.red(`\nScaffold failed: ${err.message}`));
      process.exit(1);
    }
  } else {
    console.log(chalk.dim('\n[3/4] Scaffold skipped (--skip-scaffold)'));
    // Collect any previously generated files for review
    writtenFiles = fs.readdirSync(componentOutputDir)
      .filter(f => f.endsWith('.swift') || f.endsWith('.kt'))
      .map(f => path.join(componentOutputDir, f));
  }

  // ── Step 4: Review + Parity ────────────────────────────────────────────
  if (writtenFiles.length > 0) {
    console.log(chalk.bold.cyan('\n[4/4] Reviewing generated files...'));

    const [reviewContent, parityContent] = await Promise.all([
      reviewGeneratedFiles(llm, decisions, writtenFiles, referenceComponents),
      checkParity(llm, decisions, writtenFiles),
    ]);

    fs.writeFileSync(path.join(componentOutputDir, 'review.md'), reviewContent, 'utf8');
    fs.writeFileSync(path.join(componentOutputDir, 'parity.md'), parityContent, 'utf8');

    const reviewHasIssues = /issue|error|missing|incorrect|wrong|❌|⚠/i.test(reviewContent);
    const parityHasIssues = /issue|error|missing|mismatch|❌|⚠/i.test(parityContent);

    if (reviewHasIssues) {
      console.log(chalk.yellow('  ⚠ Review found issues — check review.md'));
    } else {
      console.log(chalk.green('  ✓ Review passed'));
    }
    if (parityHasIssues) {
      console.log(chalk.yellow('  ⚠ Parity issues found — check parity.md'));
    } else {
      console.log(chalk.green('  ✓ Parity passed'));
    }
  } else {
    console.log(chalk.dim('\n[4/4] No files to review'));
  }

  // ── Summary ────────────────────────────────────────────────────────────
  console.log(chalk.bold.cyan('\n── Done ──\n'));
  console.log(chalk.bold(`Output: ${componentOutputDir}/`));
  console.log(chalk.dim('\nFiles generated:'));
  for (const f of writtenFiles) console.log(chalk.dim(`  ${path.basename(f)}`));
  console.log(chalk.dim('\nReports:'));
  console.log(chalk.dim('  decisions.md   — agent reasoning, correct if wrong'));
  console.log(chalk.dim('  token-audit.md — token cross-reference'));
  if (writtenFiles.length > 0) {
    console.log(chalk.dim('  review.md      — pattern + token review'));
    console.log(chalk.dim('  parity.md      — iOS ↔ Android alignment'));
  }
  console.log(chalk.bold('\nNext step:'));
  console.log('  Review all output files, then move to source when clean:');
  console.log(chalk.dim(`  iOS/Catalyst/Sources/Catalyst/Components/${decisions.component.replace(/-([a-z])/g, (_, c) => c.toUpperCase()).replace(/^./, c => c.toUpperCase())}s/`));
  console.log(chalk.dim(`  android/catalyst/src/main/java/com/haiilo/catalyst/components/${componentName.replace(/-/g, '')}/`));
}

main().catch(err => {
  console.error(chalk.red(`\nUnexpected error: ${err.message}`));
  if (process.env.DEBUG) console.error(err.stack);
  process.exit(1);
});
