#!/usr/bin/env node
/**
 * spec-validate-agent.js
 *
 * Validates the machine-readable contract inside spec.md.
 */

import { program } from 'commander';
import chalk from 'chalk';
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';
import {
  parseSpecContract,
  looksLikeTokenPath,
  isSentinelTokenValue,
  normalizeTokenValue,
} from './spec-contract.js';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const OUTPUT_DIR = path.join(__dirname, 'output');

const ALLOWED_INTERACTIVITY = new Set(['interactive', 'non-interactive']);
const ALLOWED_STATES = new Set(['normal', 'hovered', 'pressed', 'focused', 'disabled', 'loading']);

program
  .requiredOption('--component <name>', 'Component name in kebab-case (e.g. badge, text-input)')
  .option('--spec <path>', 'Path to spec.md (defaults to output/<component>/spec.md)')
  .parse(process.argv);

const opts = program.opts();
const component = String(opts.component).toLowerCase();
const componentOutputDir = path.join(OUTPUT_DIR, component);
const specPath = opts.spec ?? path.join(componentOutputDir, 'spec.md');
const reportPath = path.join(componentOutputDir, 'spec-validation.md');

function addIssue(issues, severity, field, message) {
  issues.push({ severity, field, message });
}

function validateContract(contract, componentName) {
  const issues = [];

  if (typeof contract.specVersion !== 'number') {
    addIssue(issues, 'error', 'specVersion', 'specVersion must be a number (currently 1).');
  }

  if (typeof contract.component !== 'string' || !/^[a-z0-9]+(?:-[a-z0-9]+)*$/.test(contract.component)) {
    addIssue(issues, 'error', 'component', 'component must be kebab-case (e.g. badge, text-input).');
  } else if (contract.component !== componentName) {
    addIssue(issues, 'error', 'component', `component must match CLI value "${componentName}".`);
  }

  if (!ALLOWED_INTERACTIVITY.has(contract.interactivity)) {
    addIssue(issues, 'error', 'interactivity', 'interactivity must be "interactive" or "non-interactive".');
  }

  if (!Array.isArray(contract.states) || contract.states.length === 0) {
    addIssue(issues, 'error', 'states', 'states must be a non-empty array.');
  } else {
    const seen = new Set();
    for (const state of contract.states) {
      if (typeof state !== 'string') {
        addIssue(issues, 'error', 'states', 'all states must be strings.');
        continue;
      }
      if (!ALLOWED_STATES.has(state)) {
        addIssue(issues, 'error', 'states', `unsupported state "${state}".`);
      }
      if (seen.has(state)) {
        addIssue(issues, 'warning', 'states', `duplicate state "${state}".`);
      }
      seen.add(state);
    }

    if (!contract.states.includes('normal')) {
      addIssue(issues, 'error', 'states', 'states must include "normal".');
    }
    if (!contract.states.includes('disabled')) {
      addIssue(issues, 'error', 'states', 'states must include "disabled".');
    }

    if (contract.interactivity === 'non-interactive') {
      if (contract.states.includes('hovered') || contract.states.includes('pressed')) {
        addIssue(issues, 'warning', 'states', 'non-interactive component includes hovered/pressed states.');
      }
    }
  }

  if (!Array.isArray(contract.sizes) || contract.sizes.length === 0) {
    addIssue(issues, 'error', 'sizes', 'sizes must be a non-empty array.');
  } else {
    const sizeNames = new Set();
    for (const size of contract.sizes) {
      if (!size || typeof size !== 'object') {
        addIssue(issues, 'error', 'sizes', 'each size must be an object.');
        continue;
      }

      if (typeof size.name !== 'string' || !size.name.trim()) {
        addIssue(issues, 'error', 'sizes[].name', 'each size must have a non-empty name.');
      } else {
        if (sizeNames.has(size.name)) {
          addIssue(issues, 'warning', 'sizes[].name', `duplicate size "${size.name}".`);
        }
        sizeNames.add(size.name);
      }

      for (const tokenField of ['heightToken', 'horizontalPaddingToken', 'verticalPaddingToken', 'fontToken']) {
        const tokenValue = normalizeTokenValue(size[tokenField]);
        if (!tokenValue) continue;
        if (!looksLikeTokenPath(tokenValue) && !isSentinelTokenValue(tokenValue)) {
          addIssue(issues, 'error', `sizes[].${tokenField}`, `invalid token value "${tokenValue}".`);
        }
      }
    }

    if (typeof contract.defaultSize !== 'string' || !sizeNames.has(contract.defaultSize)) {
      addIssue(issues, 'error', 'defaultSize', 'defaultSize must match one size.name.');
    }
  }

  if (!Array.isArray(contract.contentCases) || contract.contentCases.length === 0) {
    addIssue(issues, 'error', 'contentCases', 'contentCases must be a non-empty array of enum-like strings.');
  }

  const sharedTokens = contract.sharedTokens ?? {};
  if (typeof sharedTokens !== 'object' || Array.isArray(sharedTokens)) {
    addIssue(issues, 'error', 'sharedTokens', 'sharedTokens must be an object.');
  } else {
    for (const [key, tokenValueRaw] of Object.entries(sharedTokens)) {
      const tokenValue = normalizeTokenValue(tokenValueRaw);
      if (!tokenValue) continue;
      if (!looksLikeTokenPath(tokenValue) && !isSentinelTokenValue(tokenValue)) {
        addIssue(issues, 'error', `sharedTokens.${key}`, `invalid token value "${tokenValue}".`);
      }
    }
  }

  if (!Array.isArray(contract.variants) || contract.variants.length === 0) {
    addIssue(issues, 'error', 'variants', 'variants must be a non-empty array.');
  } else {
    const variantNames = new Set();
    for (const variant of contract.variants) {
      if (!variant || typeof variant !== 'object') {
        addIssue(issues, 'error', 'variants', 'each variant must be an object.');
        continue;
      }
      if (typeof variant.name !== 'string' || !variant.name.trim()) {
        addIssue(issues, 'error', 'variants[].name', 'each variant must have a non-empty name.');
      } else {
        if (variantNames.has(variant.name)) {
          addIssue(issues, 'warning', 'variants[].name', `duplicate variant "${variant.name}".`);
        }
        variantNames.add(variant.name);
      }

      const stateTokens = variant.stateTokens;
      if (!stateTokens || typeof stateTokens !== 'object' || Array.isArray(stateTokens)) {
        addIssue(issues, 'error', `variants.${variant.name ?? 'unknown'}.stateTokens`, 'stateTokens must be an object keyed by state.');
        continue;
      }

      for (const [stateName, stateConfig] of Object.entries(stateTokens)) {
        if (!ALLOWED_STATES.has(stateName)) {
          addIssue(issues, 'error', `variants.${variant.name}.stateTokens`, `unsupported state "${stateName}".`);
          continue;
        }
        if (!stateConfig || typeof stateConfig !== 'object') {
          addIssue(issues, 'error', `variants.${variant.name}.stateTokens.${stateName}`, 'state config must be an object.');
          continue;
        }

        for (const tokenField of ['background', 'foreground', 'border', 'focusRing']) {
          const tokenValue = normalizeTokenValue(stateConfig[tokenField]);
          if (!tokenValue) continue;
          if (!looksLikeTokenPath(tokenValue) && !isSentinelTokenValue(tokenValue)) {
            addIssue(
              issues,
              'error',
              `variants.${variant.name}.stateTokens.${stateName}.${tokenField}`,
              `invalid token value "${tokenValue}".`
            );
          }
        }
      }
    }
  }

  if (Array.isArray(contract.missingTokens)) {
    for (const tokenPathRaw of contract.missingTokens) {
      const tokenPath = normalizeTokenValue(tokenPathRaw);
      if (!tokenPath) continue;
      if (!looksLikeTokenPath(tokenPath)) {
        addIssue(issues, 'error', 'missingTokens', `missingTokens entry "${tokenPath}" is not a valid token path.`);
      }
    }
  }

  return issues;
}

function buildReport(componentName, specFile, issues) {
  const date = new Date().toISOString().split('T')[0];
  const errors = issues.filter(i => i.severity === 'error');
  const warnings = issues.filter(i => i.severity === 'warning');

  let md = `# Spec Validation — ${componentName}\n\n`;
  md += `Generated: ${date}  \n`;
  md += `Spec: \`${specFile}\`\n\n`;
  md += `## Summary\n\n`;
  md += `- Errors: **${errors.length}**\n`;
  md += `- Warnings: **${warnings.length}**\n\n`;

  if (issues.length === 0) {
    md += `All validation checks passed.\n`;
    return md;
  }

  md += `## Findings\n\n`;
  md += `| Severity | Field | Message |\n|---|---|---|\n`;
  for (const issue of issues) {
    const severity = issue.severity === 'error' ? '❌ Error' : '⚠️ Warning';
    md += `| ${severity} | \`${issue.field}\` | ${issue.message} |\n`;
  }

  return md;
}

async function main() {
  console.log(chalk.bold.cyan('\nCatalyst Spec Validate Agent'));
  console.log(chalk.dim(`Component: ${component}\n`));

  if (!fs.existsSync(specPath)) {
    console.error(chalk.red(`No spec found at: ${specPath}`));
    console.error(chalk.dim(`Create one with: node spec-template-agent.js --component=${component}`));
    process.exit(1);
  }

  const specContent = fs.readFileSync(specPath, 'utf8');
  const contract = parseSpecContract(specContent);

  if (!contract) {
    fs.mkdirSync(componentOutputDir, { recursive: true });
    const message = '# Spec Validation\n\n❌ No machine-readable contract found. Add a ```json block with specVersion/component fields.\n';
    fs.writeFileSync(reportPath, message, 'utf8');
    console.error(chalk.red('No machine-readable contract found in spec.md.'));
    console.error(chalk.dim('Add a ```json contract block under "Spec Contract (Machine Readable)".'));
    process.exit(1);
  }

  const issues = validateContract(contract, component);
  fs.mkdirSync(componentOutputDir, { recursive: true });
  fs.writeFileSync(reportPath, buildReport(component, specPath, issues), 'utf8');

  const errors = issues.filter(i => i.severity === 'error').length;
  const warnings = issues.filter(i => i.severity === 'warning').length;

  if (errors > 0) {
    console.error(chalk.red(`Validation failed: ${errors} error(s), ${warnings} warning(s).`));
    console.error(chalk.cyan(`Report: ${reportPath}`));
    process.exit(1);
  }

  if (warnings > 0) {
    console.log(chalk.yellow(`Validation passed with ${warnings} warning(s).`));
  } else {
    console.log(chalk.green('Validation passed with no issues.'));
  }
  console.log(chalk.cyan(`Report: ${reportPath}`));
}

main().catch(err => {
  console.error(chalk.red(`\nError: ${err.message}`));
  process.exit(1);
});
