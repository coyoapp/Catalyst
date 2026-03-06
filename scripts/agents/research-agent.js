#!/usr/bin/env node
/**
 * research-agent.js
 *
 * OPTIONAL. Uses an LLM via GitHub Models to generate a component spec
 * based on the component name, the existing token vocabulary, and Catalyst
 * conventions. Requires a GitHub Personal Access Token with models:read scope.
 * Your GitHub Copilot subscription covers the usage — no separate vendor
 * account is needed.
 *
 * Output: output/{component}/spec.md
 *
 * You can skip this entirely and write spec.md by hand if you already have
 * the Figma spec. The token-audit-agent and scaffold-agent both work with
 * a manually written spec.md.
 *
 * Usage:
 *   node research-agent.js --component=badge
 *   node research-agent.js --component=text-input --context="A single-line text input with optional label and error state"
 */

import { program } from 'commander';
import chalk from 'chalk';
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const REPO_ROOT = path.resolve(__dirname, '..', '..');
const TOKENS_SRC = path.join(REPO_ROOT, 'tokens', 'src');
const OUTPUT_DIR = path.join(__dirname, 'output');

// ---------------------------------------------------------------------------
// CLI
// ---------------------------------------------------------------------------

program
  .requiredOption('--component <name>', 'Component name in kebab-case (e.g. badge, text-input)')
  .option('--context <description>', 'Optional description to give the LLM more context about the component')
  .option('--model <model>', 'Override model name (default: gpt-4o). Other options: claude-sonnet-4-5, gpt-4o-mini')
  .parse(process.argv);

const opts = program.opts();
const componentName = opts.component.toLowerCase();
const componentOutputDir = path.join(OUTPUT_DIR, componentName);
const specOutputPath = path.join(componentOutputDir, 'spec.md');

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
// Token vocabulary loader
// ---------------------------------------------------------------------------

function loadTokenVocabulary() {
  const vocab = { colors: [], spacing: [], sizes: [], borderRadius: [], borderWidth: [], typography: [] };

  function walk(dir) {
    for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
      if (entry.isDirectory()) {
        walk(path.join(dir, entry.name));
      } else if (entry.name.endsWith('.json')) {
        const raw = JSON.parse(fs.readFileSync(path.join(dir, entry.name), 'utf8'));
        collectTokens(raw, []);
      }
    }
  }

  function collectTokens(obj, pathSoFar) {
    for (const [key, val] of Object.entries(obj)) {
      const p = [...pathSoFar, key];
      if (val && typeof val === 'object' && 'value' in val) {
        const tokenPath = p.join('.');
        const type = val.type ?? '';
        if (type === 'color' && (tokenPath.includes('theme') || tokenPath.includes('ui'))) {
          vocab.colors.push(tokenPath);
        } else if (type === 'spacing') {
          vocab.spacing.push(tokenPath);
        } else if (type === 'sizing') {
          vocab.sizes.push(tokenPath);
        } else if (type === 'borderRadius') {
          vocab.borderRadius.push(tokenPath);
        } else if (type === 'borderWidth') {
          vocab.borderWidth.push(tokenPath);
        } else if (type === 'typography') {
          vocab.typography.push(tokenPath);
        }
      } else if (val && typeof val === 'object') {
        collectTokens(val, p);
      }
    }
  }

  walk(TOKENS_SRC);
  return vocab;
}

// ---------------------------------------------------------------------------
// Prompt builder
// ---------------------------------------------------------------------------

function buildPrompt(vocab) {
  const contextLine = opts.context
    ? `Additional context from the developer: "${opts.context}"\n\n`
    : '';

  return {
    system: `You are a senior design system engineer specialising in native mobile UI (SwiftUI and Jetpack Compose).
You are helping build the Catalyst Mobile Design System by Haiilo.
The system uses design tokens generated from Figma via Style Dictionary.
Your job is to produce precise, actionable component specifications in markdown.
Be concise and technical. Do not pad the output. Use tables wherever structure helps clarity.`,

    user: `${contextLine}Generate a component specification for the **${componentName}** component.

## Catalyst conventions to follow

### Existing token vocabulary
Available color tokens (semantic only — use these, not hex values):
${vocab.colors.slice(0, 40).map(t => `- \`${t}\``).join('\n')}

Available spacing tokens:
${vocab.spacing.map(t => `- \`${t}\``).join('\n')}

Available size tokens:
${vocab.sizes.map(t => `- \`${t}\``).join('\n')}

Available border radius tokens:
${vocab.borderRadius.map(t => `- \`${t}\``).join('\n')}

Available border width tokens:
${vocab.borderWidth.map(t => `- \`${t}\``).join('\n')}

Available typography tokens:
${vocab.typography.map(t => `- \`${t}\``).join('\n')}

### Architecture pattern (from the existing Button component)
- Each component has: a state style config struct, a state machine (normal/hovered/pressed/focused/disabled), a ViewModifier for styling, a layout Builder view, and a public Cat{Name} view.
- Token references in Swift use CatColors, CatSpacing, CatSizes, CatBorderRadius, CatBorderWidth, CatTypography.
- Theme configs live in CatTheme.Components.{Name}s.Primary.defaultConfig etc.
- States use: CatColors.Ui.Background.muted + CatColors.Ui.Font.muted for disabled state.

## Required spec output format

Produce a markdown document with ALL of these sections:

# Component Spec — ${componentName}

## Overview
Brief description (2–3 sentences): what this component is, primary use case, key behaviours.

## Variants
Table: | Variant | Description | When to use |

## Sizes
Table: | Size case | Token | px equivalent |

## States
Table: | State | Triggered by | Visual change |

## Content Model
What can be inside this component? Text only, icon, icon+text, badge count, dot indicator etc.
List the enum cases you'd recommend for Cat${componentName.replace(/-/g, '')}Content.

## Token Requirements
Table: | Visual property | Token path | Notes |
List EVERY visual property and which token from the vocabulary above maps to it.
If no existing token fits, mark the path as MISSING and suggest a W3C-format path.

## Open Questions
List any design decisions that need clarification from the design team before implementation.

## iOS Notes
Any SwiftUI-specific considerations (protocol choice, env values needed, animation etc.)

## Android Notes
Any Jetpack Compose-specific considerations or known gaps vs iOS.`,
  };
}

// ---------------------------------------------------------------------------
// Main
// ---------------------------------------------------------------------------

async function main() {
  console.log(chalk.bold.cyan(`\nCatalyst Research Agent`));
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

  // Load token vocabulary
  console.log(chalk.dim(`Loading token vocabulary...`));
  const vocab = loadTokenVocabulary();
  console.log(chalk.green(
    `  Loaded: ${vocab.colors.length} colors, ${vocab.spacing.length} spacing, ` +
    `${vocab.sizes.length} sizes, ${vocab.borderRadius.length} radii, ` +
    `${vocab.borderWidth.length} border widths, ${vocab.typography.length} typography`
  ));

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
  const { system, user } = buildPrompt(vocab);
  console.log(chalk.dim(`\nGenerating spec (this may take 15–30 seconds)...`));

  let spec;
  try {
    spec = await llm.complete(system, user);
  } catch (err) {
    console.error(chalk.red(`\nLLM error: ${err.message}`));
    process.exit(1);
  }

  // Write output
  fs.mkdirSync(componentOutputDir, { recursive: true });
  fs.writeFileSync(specOutputPath, spec);

  console.log(chalk.bold.green(`\nSpec written to:`));
  console.log(chalk.cyan(`  ${specOutputPath}`));

  console.log(chalk.bold(`\nNext steps:`));
  console.log(`  1. ${chalk.cyan('Review and edit')} the spec — the LLM may not know component-specific Figma details`);
  console.log(`  2. ${chalk.cyan('Run the token audit:')}  node token-audit-agent.js --component=${componentName}`);
  console.log(`  3. ${chalk.cyan('Scaffold the component:')} node scaffold-agent.js --component=${componentName}`);
}

main().catch(err => {
  console.error(chalk.red(`\nUnexpected error: ${err.message}`));
  process.exit(1);
});
