#!/usr/bin/env node
/**
 * spec-template-agent.js
 *
 * Creates a machine-readable spec template that other agents can process
 * deterministically.
 */

import { program } from 'commander';
import chalk from 'chalk';
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const OUTPUT_DIR = path.join(__dirname, 'output');

program
  .requiredOption('--component <name>', 'Component name in kebab-case (e.g. badge, text-input)')
  .option('--spec <path>', 'Custom output path for spec.md')
  .option('--force', 'Overwrite an existing spec.md', false)
  .parse(process.argv);

const opts = program.opts();
const component = String(opts.component).toLowerCase();
const specPath = opts.spec ?? path.join(OUTPUT_DIR, component, 'spec.md');

function buildTemplate(componentName) {
  const today = new Date().toISOString().split('T')[0];
  const fence = '```';

  return `# Component Spec — ${componentName}

**Status:** Draft
**Author:** (your name)
**Last updated:** ${today}

## Spec Contract (Machine Readable)

Fill this JSON first. Other agents will use this as source of truth.

${fence}json
{
  "specVersion": 1,
  "component": "${componentName}",
  "interactivity": "non-interactive",
  "states": ["normal", "focused", "disabled"],
  "sizes": [
    {
      "name": "small",
      "heightToken": "size.lg",
      "horizontalPaddingToken": "spacing.xs",
      "verticalPaddingToken": "spacing.xxs",
      "fontToken": "typography.s2"
    },
    {
      "name": "medium",
      "heightToken": "size.xl",
      "horizontalPaddingToken": "spacing.sm",
      "verticalPaddingToken": "spacing.xs",
      "fontToken": "typography.s2"
    }
  ],
  "defaultSize": "small",
  "contentCases": ["text(String)", "count(Int)", "dot"],
  "sharedTokens": {
    "cornerRadius": "border-radius.full",
    "borderWidth": "none"
  },
  "variants": [
    {
      "name": "primary",
      "stateTokens": {
        "normal": {
          "background": "color.theme.primary.bg",
          "foreground": "color.theme.primary.fill",
          "border": "none",
          "focusRing": "color.ui.border.focus"
        },
        "focused": {
          "background": "color.theme.primary.bg",
          "foreground": "color.theme.primary.fill",
          "border": "none",
          "focusRing": "color.ui.border.focus"
        },
        "disabled": {
          "background": "color.ui.background.muted",
          "foreground": "color.ui.font.muted",
          "border": "none",
          "focusRing": "none"
        }
      }
    }
  ],
  "missingTokens": [
    "component.${componentName}.size.dot"
  ],
  "notes": [
    "Keep content concise for small size.",
    "Use 99+ formatting for high counts."
  ]
}
${fence}

## Human Notes

Use this section for context that does not affect generation.

### Overview
- What this component is
- Where it appears
- Any interaction caveats

### Accessibility
- Labeling guidance
- VoiceOver/TalkBack behavior
- Minimum touch target expectations

### Open Questions
- Pending design decisions
- Pending tokens from design team
`;
}

async function main() {
  console.log(chalk.bold.cyan('\nCatalyst Spec Template Agent'));
  console.log(chalk.dim(`Component: ${component}\n`));

  fs.mkdirSync(path.dirname(specPath), { recursive: true });

  if (fs.existsSync(specPath) && !opts.force) {
    console.error(chalk.red(`Spec already exists at ${specPath}`));
    console.error(chalk.dim('Use --force to overwrite.'));
    process.exit(1);
  }

  fs.writeFileSync(specPath, buildTemplate(component), 'utf8');

  console.log(chalk.green(`Template written to:`));
  console.log(chalk.cyan(`  ${specPath}`));
  console.log(chalk.bold('\nNext steps:'));
  console.log(`  1. Fill the JSON under ${chalk.cyan('Spec Contract (Machine Readable)')}`);
  console.log(`  2. Validate it: ${chalk.dim(`node spec-validate-agent.js --component=${component}`)}`);
  console.log(`  3. Audit tokens: ${chalk.dim(`node token-audit-agent.js --component=${component}`)}`);
}

main().catch(err => {
  console.error(chalk.red(`\nError: ${err.message}`));
  process.exit(1);
});
