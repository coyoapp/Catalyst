#!/usr/bin/env node
/**
 * orchestrator.js
 *
 * Convenience runner that chains agents in sequence.
 * Each agent is still independently runnable — this is just a shortcut.
 *
 * Usage:
 *   node orchestrator.js --component=badge
 *   node orchestrator.js --component=badge --skip-research
 *   node orchestrator.js --component=badge --skip-research --skip-review
 *   node orchestrator.js --component=badge --only=audit
 *   node orchestrator.js --component=badge --only=scaffold
 */

import { program } from 'commander';
import chalk from 'chalk';
import { spawn } from 'child_process';
import path from 'path';
import { fileURLToPath } from 'url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));

// ---------------------------------------------------------------------------
// CLI
// ---------------------------------------------------------------------------

program
  .requiredOption('--component <name>', 'Component name in kebab-case (e.g. badge, text-input)')
  .option('--skip-research', 'Skip the research agent (use if you have a spec.md already)', false)
  .option('--skip-validate', 'Skip spec validation (not recommended)', false)
  .option('--skip-review', 'Skip the review agent', false)
  .option('--only <agent>', 'Run only one agent: template | research | validate | audit | scaffold | review')
  .option('--context <description>', 'Context passed to the research agent')
  .option('--has-content-enum', 'Passed to scaffold: generate a Cat{Name}Content enum', false)
  .option('--has-border-variant', 'Passed to scaffold: include borderConfig in theme extension', false)
  .option('--sizes <sizes>', 'Passed to scaffold: comma-separated size cases', 'small,medium')
  .option('--default-size <size>', 'Passed to scaffold: default size', 'small')
  .parse(process.argv);

const opts = program.opts();
const component = opts.component;

// ---------------------------------------------------------------------------
// Runner
// ---------------------------------------------------------------------------

function runAgent(scriptName, extraArgs = []) {
  return new Promise((resolve, reject) => {
    const agentPath = path.join(__dirname, scriptName);
    const args = ['--component', component, ...extraArgs];

    console.log(chalk.bold.dim(`\n${'─'.repeat(60)}`));
    console.log(chalk.bold(`Running: node ${scriptName} --component=${component} ${extraArgs.join(' ')}`));
    console.log(chalk.bold.dim('─'.repeat(60)));

    const child = spawn('node', [agentPath, ...args], {
      stdio: 'inherit',
      cwd: __dirname,
    });

    child.on('close', code => {
      if (code === 0) {
        resolve();
      } else {
        reject(new Error(`${scriptName} exited with code ${code}`));
      }
    });

    child.on('error', err => {
      reject(new Error(`Failed to start ${scriptName}: ${err.message}`));
    });
  });
}

// ---------------------------------------------------------------------------
// Agent configs
// ---------------------------------------------------------------------------

function getAgentPlan() {
  const plan = [];

  if (opts.only) {
    const agentMap = {
      research: {
        script: 'research-agent.js',
        args: opts.context ? ['--context', opts.context] : [],
        label: 'Research',
      },
      template: {
        script: 'spec-template-agent.js',
        args: [],
        label: 'Spec Template',
      },
      validate: {
        script: 'spec-validate-agent.js',
        args: [],
        label: 'Spec Validate',
      },
      audit: {
        script: 'token-audit-agent.js',
        args: [],
        label: 'Token Audit',
      },
      scaffold: {
        script: 'scaffold-agent.js',
        args: buildScaffoldArgs(),
        label: 'Scaffold',
      },
      review: {
        script: 'review-agent.js',
        args: [],
        label: 'Review',
      },
    };

    const agent = agentMap[opts.only];
    if (!agent) {
      console.error(chalk.red(`Unknown agent: ${opts.only}. Use: template | research | validate | audit | scaffold | review`));
      process.exit(1);
    }
    return [agent];
  }

  // Full sequence
  if (!opts.skipResearch) {
    plan.push({
      script: 'research-agent.js',
      args: opts.context ? ['--context', opts.context] : [],
      label: 'Research',
      optional: true, // Won't abort the chain if it fails (e.g. no API key)
    });
  }

  if (!opts.skipValidate) {
    plan.push({
      script: 'spec-validate-agent.js',
      args: [],
      label: 'Spec Validate',
    });
  }

  plan.push({
    script: 'token-audit-agent.js',
    args: [],
    label: 'Token Audit',
  });

  plan.push({
    script: 'scaffold-agent.js',
    args: buildScaffoldArgs(),
    label: 'Scaffold',
  });

  if (!opts.skipReview) {
    plan.push({
      script: 'review-agent.js',
      args: [],
      label: 'Review',
      optional: true,
    });
  }

  return plan;
}

function buildScaffoldArgs() {
  const args = [];
  if (opts.hasContentEnum) args.push('--has-content-enum');
  if (opts.hasBorderVariant) args.push('--has-border-variant');
  if (opts.sizes) args.push('--sizes', opts.sizes);
  if (opts.defaultSize) args.push('--default-size', opts.defaultSize);
  return args;
}

// ---------------------------------------------------------------------------
// Main
// ---------------------------------------------------------------------------

async function main() {
  console.log(chalk.bold.magenta(`\nCatalyst Agent Orchestrator`));
  console.log(chalk.dim(`Component: ${component}`));

  const plan = getAgentPlan();

  console.log(chalk.dim(`\nPlan:`));
  plan.forEach((step, i) => {
    const optionalTag = step.optional ? chalk.dim(' (optional — skipped if no API key)') : '';
    console.log(chalk.dim(`  ${i + 1}. ${step.label}${optionalTag}`));
  });

  const results = { passed: [], failed: [], skipped: [] };

  for (const step of plan) {
    try {
      await runAgent(step.script, step.args);
      results.passed.push(step.label);
    } catch (err) {
      if (step.optional) {
        console.log(chalk.yellow(`\n${step.label} skipped: ${err.message}`));
        results.skipped.push(step.label);
      } else {
        console.error(chalk.red(`\n${step.label} failed: ${err.message}`));
        results.failed.push(step.label);
        break; // Stop the chain on non-optional failure
      }
    }
  }

  // Summary
  const outputDir = path.join(__dirname, 'output', component);
  console.log(chalk.bold.magenta(`\n${'═'.repeat(60)}`));
  console.log(chalk.bold.magenta(`Orchestrator Complete — ${component}`));
  console.log(chalk.bold.magenta('═'.repeat(60)));

  if (results.passed.length) {
    console.log(chalk.green(`\nCompleted: ${results.passed.join(' → ')}`));
  }
  if (results.skipped.length) {
    console.log(chalk.yellow(`Skipped:   ${results.skipped.join(', ')}`));
  }
  if (results.failed.length) {
    console.log(chalk.red(`Failed:    ${results.failed.join(', ')}`));
    process.exit(1);
  }

  console.log(chalk.bold(`\nAll output staged at:`));
  console.log(chalk.cyan(`  ${outputDir}/`));
  console.log(chalk.dim(`\nFiles to review:`));

  const fileOrder = [
    'spec.md',
    'spec-validation.md',
    'token-audit.md',
    `Cat${component.split('-').map(w => w[0].toUpperCase() + w.slice(1)).join('')}Style.swift`,
    `Cat${component.split('-').map(w => w[0].toUpperCase() + w.slice(1)).join('')}Builder.swift`,
    `CatTheme+${component.split('-').map(w => w[0].toUpperCase() + w.slice(1)).join('')}.swift`,
    `${component.split('-').map(w => w[0].toUpperCase() + w.slice(1)).join('')}.kt`,
    'review.md',
  ];

  for (const f of fileOrder) {
    console.log(chalk.dim(`  • ${f}`));
  }

  console.log(`\nSee ${chalk.cyan('scripts/agents/AGENTS.md')} for next steps.`);
}

main().catch(err => {
  console.error(chalk.red(`\nOrchestrator error: ${err.message}`));
  process.exit(1);
});
