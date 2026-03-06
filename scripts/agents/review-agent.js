#!/usr/bin/env node
/**
 * review-agent.js
 *
 * Uses an LLM via GitHub Models to review the generated Swift and Kotlin
 * files against the component spec, the existing Button component as the
 * reference pattern, and Catalyst conventions. Requires a GitHub Personal
 * Access Token with models:read scope — covered by your Copilot subscription.
 *
 * Output: output/{component}/review.md
 *
 * Usage:
 *   node review-agent.js --component=badge
 */

import { program } from 'commander';
import chalk from 'chalk';
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const REPO_ROOT = path.resolve(__dirname, '..', '..');
const OUTPUT_DIR = path.join(__dirname, 'output');

// Reference files from the Button component — the gold standard
const REFERENCE_FILES = [
  {
    label: 'Reference: CatButtonStyle.swift',
    path: path.join(REPO_ROOT, 'iOS/Catalyst/Sources/Catalyst/Components/Buttons/CatButtonStyle.swift'),
  },
  {
    label: 'Reference: CatButtonBuilder.swift',
    path: path.join(REPO_ROOT, 'iOS/Catalyst/Sources/Catalyst/Components/Buttons/CatButtonBuilder.swift'),
  },
  {
    label: 'Reference: CatTheme.swift (excerpt)',
    path: path.join(REPO_ROOT, 'iOS/Catalyst/Sources/Catalyst/Theme/CatTheme.swift'),
    maxLines: 80, // Just enough to see the pattern, not the full 556 lines
  },
];

// ---------------------------------------------------------------------------
// CLI
// ---------------------------------------------------------------------------

program
  .requiredOption('--component <name>', 'Component name in kebab-case (e.g. badge, text-input)')
  .option('--model <model>', 'Override model name (default: gpt-4o). Other options: claude-sonnet-4-5, gpt-4o-mini')
  .parse(process.argv);

const opts = program.opts();
const componentName = opts.component.toLowerCase();
const componentOutputDir = path.join(OUTPUT_DIR, componentName);
const reviewOutputPath = path.join(componentOutputDir, 'review.md');

// ---------------------------------------------------------------------------
// LLM client — GitHub Models (OpenAI-compatible endpoint)
// Authenticated with a GitHub PAT; covered by your Copilot subscription.
// ---------------------------------------------------------------------------

async function createLLMClient() {
  const token = process.env.GITHUB_TOKEN;

  if (!token || token === 'github_pat_') {
    throw new Error(
      'GITHUB_TOKEN not set.\n' +
      'Create a GitHub Personal Access Token with "Models: Read" permission at:\n' +
      '  https://github.com/settings/personal-access-tokens/new\n' +
      'Then add it to scripts/agents/.env as GITHUB_TOKEN=github_pat_...'
    );
  }

  const { default: OpenAI } = await import('openai');
  const client = new OpenAI({
    baseURL: 'https://models.inference.ai.azure.com',
    apiKey: token,
  });
  const model = opts.model ?? process.env.MODEL ?? 'gpt-4o';

  return {
    provider: 'github-models',
    model,
    async complete(systemPrompt, userPrompt) {
      const response = await client.chat.completions.create({
        model: this.model,
        messages: [
          { role: 'system', content: systemPrompt },
          { role: 'user', content: userPrompt },
        ],
        max_tokens: 4096,
      });
      return response.choices[0]?.message?.content ?? '';
    },
  };
}

// ---------------------------------------------------------------------------
// File loader helpers
// ---------------------------------------------------------------------------

function readFileIfExists(filePath, maxLines) {
  if (!fs.existsSync(filePath)) return null;
  const content = fs.readFileSync(filePath, 'utf8');
  if (!maxLines) return content;
  return content.split('\n').slice(0, maxLines).join('\n') + '\n... (truncated)';
}

function loadGeneratedFiles() {
  const manifestPath = path.join(componentOutputDir, 'manifest.json');
  if (!fs.existsSync(manifestPath)) return [];

  const manifest = JSON.parse(fs.readFileSync(manifestPath, 'utf8'));
  return manifest.files
    .map(f => ({
      label: f.name,
      content: readFileIfExists(f.stagedPath),
      targetDir: f.targetDir,
    }))
    .filter(f => f.content !== null);
}

// ---------------------------------------------------------------------------
// Prompt builder
// ---------------------------------------------------------------------------

function buildReviewPrompt(generatedFiles, referenceFiles, specContent, auditContent) {
  let userPrompt = `Please review the following generated Catalyst Design System component files.

## Component: ${componentName}

`;

  if (specContent) {
    userPrompt += `### Component Spec\n\`\`\`markdown\n${specContent.slice(0, 2000)}\n\`\`\`\n\n`;
  }

  if (auditContent) {
    userPrompt += `### Token Audit Summary\n\`\`\`markdown\n${auditContent.slice(0, 1000)}\n\`\`\`\n\n`;
  }

  userPrompt += `---\n\n## Generated Files to Review\n\n`;
  for (const f of generatedFiles) {
    const ext = f.label.endsWith('.kt') ? 'kotlin' : 'swift';
    userPrompt += `### ${f.label}\n\`\`\`${ext}\n${f.content}\n\`\`\`\n\n`;
  }

  userPrompt += `---\n\n## Reference: Existing Button Component (the gold standard pattern)\n\n`;
  for (const ref of referenceFiles) {
    if (ref.content) {
      const ext = ref.path.endsWith('.kt') ? 'kotlin' : 'swift';
      userPrompt += `### ${ref.label}\n\`\`\`${ext}\n${ref.content}\n\`\`\`\n\n`;
    }
  }

  userPrompt += `---\n\n## Review Instructions

Produce a structured review in markdown with these exact sections:

# Code Review — ${componentName}

## Overall Assessment
One paragraph: is this ready to move to source, or does it need significant work?

## Token Usage
- Any hardcoded color, spacing, or size values that should reference a Catalyst token?
- Any token references that look wrong or could be improved?

## Pattern Consistency
- Does the file structure mirror the Button pattern (StyleTypes / ViewModifier / Builder / Public View / Theme extension)?
- Are naming conventions consistent with CatButton, CatButtonStyle, CatButtonStateStyleConfig etc.?
- Are access modifiers (public/internal) appropriate?

## State Machine
- Is the resolveState() logic correct and complete?
- Are all relevant states handled (normal, hovered, pressed, focused, disabled)?
- Any missing state transitions for this specific component type?

## Accessibility
- Is there a minimum touch target size (44pt minimum, per Apple HIG)?
- Are there any missing accessibility labels or VoiceOver considerations?
- Any Dynamic Type concerns?

## Android Completeness
- Which TODO markers remain in the Kotlin file?
- What is the minimum required to unblock Android implementation?

## Specific Line-Level Suggestions
List any specific lines to change, in the format:
- **File:Line** — Current code → Suggested change — Reason

## Pre-merge Checklist
A checklist the developer should tick before moving files to source:
- [ ] item 1
- [ ] item 2
...`;

  return userPrompt;
}

// ---------------------------------------------------------------------------
// Main
// ---------------------------------------------------------------------------

async function main() {
  console.log(chalk.bold.cyan(`\nCatalyst Review Agent`));
  console.log(chalk.dim(`Component: ${componentName}\n`));

  // Load .env if present
  const envPath = path.join(__dirname, '.env');
  if (fs.existsSync(envPath)) {
    const envLines = fs.readFileSync(envPath, 'utf8').split('\n');
    for (const line of envLines) {
      const [key, ...rest] = line.split('=');
      if (key && rest.length) {
        process.env[key.trim()] = rest.join('=').trim();
      }
    }
  }

  // Check component output dir exists
  if (!fs.existsSync(componentOutputDir)) {
    console.error(chalk.red(`\nNo output found for "${componentName}".`));
    console.error(chalk.dim(`Run scaffold-agent first: node scaffold-agent.js --component=${componentName}`));
    process.exit(1);
  }

  // Load generated files via manifest
  const generatedFiles = loadGeneratedFiles();
  if (generatedFiles.length === 0) {
    console.error(chalk.red(`\nNo generated files found in ${componentOutputDir}/`));
    console.error(chalk.dim(`Run scaffold-agent first: node scaffold-agent.js --component=${componentName}`));
    process.exit(1);
  }
  console.log(chalk.green(`  Found ${generatedFiles.length} generated file(s) to review`));

  // Load reference files
  const referenceFiles = REFERENCE_FILES.map(ref => ({
    ...ref,
    content: readFileIfExists(ref.path, ref.maxLines),
  })).filter(f => f.content !== null);
  console.log(chalk.green(`  Loaded ${referenceFiles.length} reference file(s) from Button component`));

  // Load spec + audit if available
  const specContent = readFileIfExists(path.join(componentOutputDir, 'spec.md'));
  const auditContent = readFileIfExists(path.join(componentOutputDir, 'token-audit.md'));
  if (specContent) console.log(chalk.green(`  Loaded spec.md`));
  if (auditContent) console.log(chalk.green(`  Loaded token-audit.md`));

  // Create LLM client
  console.log(chalk.dim(`\nConnecting to LLM...`));
  let llm;
  try {
    llm = await createLLMClient();
    console.log(chalk.green(`  Using ${llm.provider} (${llm.model})`));
  } catch (err) {
    console.error(chalk.red(`\n${err.message}`));
    process.exit(1);
  }

  // Build and send prompt
  const systemPrompt = `You are a senior iOS and Android engineer reviewing code for the Catalyst Mobile Design System by Haiilo.
The system uses SwiftUI and Jetpack Compose with design tokens generated from Figma via Style Dictionary.
You are thorough, precise, and constructive. You point out real issues without nitpicking style preferences.
You compare against the existing Button component as the gold-standard reference implementation.`;

  const userPrompt = buildReviewPrompt(generatedFiles, referenceFiles, specContent, auditContent);

  console.log(chalk.dim(`\nReviewing generated files (this may take 15–30 seconds)...`));

  let review;
  try {
    review = await llm.complete(systemPrompt, userPrompt);
  } catch (err) {
    console.error(chalk.red(`\nLLM error: ${err.message}`));
    process.exit(1);
  }

  // Write report
  fs.writeFileSync(reviewOutputPath, review);

  console.log(chalk.bold.green(`\nReview written to:`));
  console.log(chalk.cyan(`  ${reviewOutputPath}`));
  console.log(chalk.bold(`\nNext steps:`));
  console.log(`  1. ${chalk.cyan('Read review.md')} and address any blocking issues`);
  console.log(`  2. Edit generated files in ${componentOutputDir}/ as needed`);
  console.log(`  3. Re-run review if you made significant changes`);
  console.log(`  4. ${chalk.cyan('Move files')} to their target directories once the review passes`);
}

main().catch(err => {
  console.error(chalk.red(`\nUnexpected error: ${err.message}`));
  process.exit(1);
});
