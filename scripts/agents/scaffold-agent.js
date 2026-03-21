#!/usr/bin/env node
/**
 * scaffold-agent.js
 *
 * Reads spec.md + token-audit.md and generates 5 files:
 *   - Cat{Name}Style.swift      (state machine types + ViewModifier)
 *   - Cat{Name}Builder.swift    (layout helper + public view)
 *   - CatTheme+{Name}.swift     (theme config extension)
 *   - {Name}.kt                 (Android Compose skeleton)
 *
 * All files are written to output/{component}/ for review.
 * NOTHING is written to iOS/ or android/ source directories.
 *
 * Usage:
 *   node scaffold-agent.js --component=badge
 *   node scaffold-agent.js --component=text-input --has-content-enum --has-border-variant
 */

import { program } from 'commander';
import chalk from 'chalk';
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';
import Handlebars from 'handlebars';
import { parseSpecContract } from './spec-contract.js';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const TEMPLATES_DIR = path.join(__dirname, 'templates');
const OUTPUT_DIR = path.join(__dirname, 'output');

// ---------------------------------------------------------------------------
// CLI
// ---------------------------------------------------------------------------

program
  .requiredOption('--component <name>', 'Component name in kebab-case (e.g. badge, text-input)')
  .option('--has-content-enum', 'Generate a Cat{Name}Content enum (for components with icon/text variants)', false)
  .option('--has-border-variant', 'Include a borderConfig in the theme extension', false)
  .option('--sizes <sizes>', 'Comma-separated size cases e.g. "small,medium,large"', 'small,medium')
  .option('--default-size <size>', 'Default size case name', 'small')
  .option('--spec <path>', 'Path to spec.md to extract additional context from')
  .parse(process.argv);

const opts = program.opts();

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

/** badge → Badge */
function toPascalCase(str) {
  return str
    .split(/[-_\s]+/)
    .map(word => word.charAt(0).toUpperCase() + word.slice(1).toLowerCase())
    .join('');
}

/** badge → badge, text-input → textInput */
function toCamelCase(str) {
  const pascal = toPascalCase(str);
  return pascal.charAt(0).toLowerCase() + pascal.slice(1);
}

/** badge → Badge, text-input → TextInput */
const componentKebab = opts.component.toLowerCase();
const PascalName = toPascalCase(componentKebab);
const camelName = toCamelCase(componentKebab);

const date = new Date().toLocaleDateString('en-US', {
  year: 'numeric', month: '2-digit', day: '2-digit'
}).replace(/\//g, '.');

// Map size case names → CatSizes token names.
// These names mirror the CatButtonSize enum cases in CatButtonStyle.swift:
//   .extraSmall → CatSizes.sizeXl   (32pt)
//   .small      → CatSizes.size2xl  (40pt)
//   .medium     → CatSizes.size3xl  (48pt)
// Add new entries here when new CatSizes tokens are introduced.
const SIZE_TOKEN_MAP = {
  'extrasmall': 'CatSizes.sizeXl',
  'extra-small': 'CatSizes.sizeXl',
  'extraSmall': 'CatSizes.sizeXl',
  'xs': 'CatSizes.sizeXs',
  'small': 'CatSizes.size2xl',
  'sm': 'CatSizes.sizeSm',
  'medium': 'CatSizes.size3xl',
  'md': 'CatSizes.sizeMd',
  'large': 'CatSizes.size4xl',
  'lg': 'CatSizes.sizeLg',
  'xlarge': 'CatSizes.size5xl',
  'xl': 'CatSizes.size5xl',
};

function sizeToken(caseName) {
  return SIZE_TOKEN_MAP[caseName.toLowerCase()] ?? `CatSizes.size2xl /* TODO: map ${caseName} to correct CatSizes token */`;
}

function sizeTokenFromContractPath(tokenPath, fallbackCaseName) {
  if (typeof tokenPath !== 'string') return sizeToken(fallbackCaseName);
  const trimmed = tokenPath.trim();
  const match = /^size\.([a-z0-9-]+)$/i.exec(trimmed);
  if (!match) return sizeToken(fallbackCaseName);
  const suffix = match[1]
    .split('-')
    .map((part, idx) => idx === 0 ? part.toLowerCase() : part.charAt(0).toUpperCase() + part.slice(1).toLowerCase())
    .join('');
  return `CatSizes.size${suffix.charAt(0).toUpperCase()}${suffix.slice(1)}`;
}

// ---------------------------------------------------------------------------
// Register Handlebars helpers
// ---------------------------------------------------------------------------

Handlebars.registerHelper('toUpperCase', str => String(str).toUpperCase());
Handlebars.registerHelper('toLowerCase', str => String(str).toLowerCase());
Handlebars.registerHelper('toCamelCase', str => {
  const pascal = String(str)
    .split(/[-_\s]+/)
    .map(word => word.charAt(0).toUpperCase() + word.slice(1).toLowerCase())
    .join('');
  return pascal.charAt(0).toLowerCase() + pascal.slice(1);
});
Handlebars.registerHelper('unless', function(conditional, options) {
  if (!conditional) return options.fn(this);
  return options.inverse(this);
});

// ---------------------------------------------------------------------------
// Template context builder
// ---------------------------------------------------------------------------

function buildTemplateContext(specContent, contract) {
  const contractSizes = Array.isArray(contract?.sizes) ? contract.sizes : [];
  const sizeNames = contractSizes.length > 0
    ? contractSizes.map(s => s.name).filter(Boolean)
    : opts.sizes.split(',').map(s => s.trim());

  // Try to extract state properties from spec, fall back to Button defaults
  const stateProperties = extractStateProperties(specContent, contract);

  // Try to extract content cases from spec
  const contentCases = extractContentCases(specContent, contract);

  const sizes = sizeNames.map(caseName => ({
    caseName,
    token: (() => {
      const fromContract = contractSizes.find(s => s?.name === caseName)?.heightToken;
      return sizeTokenFromContractPath(fromContract, caseName);
    })(),
  }));

  return {
    PascalName,
    camelName,
    componentKebab,
    date,
    hasContentEnum: opts.hasContentEnum || contentCases.length > 0,
    hasBorderVariant: opts.hasBorderVariant,
    stateProperties,
    contentCases: contentCases.length > 0 ? contentCases : [`text(String)`],
    contentEnumHasTodo: contentCases.length === 0,
    firstContentCase: contentCases[0]?.split('(')[0] ?? 'text("Label")',
    sizes,
    defaultSize: contract?.defaultSize ?? opts.defaultSize,
  };
}

function extractStateProperties(specContent, contract) {
  if (contract?.interactivity === 'non-interactive') {
    return [];
  }

  // Default: mirror Button's state properties
  const defaults = [
    { name: 'isUnderlined', type: 'Bool' },
    { name: 'hasSecondaryFocusRing', type: 'Bool' },
    { name: 'scale', type: 'CGFloat' },
  ];

  if (!specContent) return defaults;

  // Look for state property hints in spec
  const extra = [];
  if (/badge.?count|number|count/i.test(specContent)) {
    extra.push({ name: 'showBadgeCount', type: 'Bool' });
  }
  if (/pulsing|pulse|animation/i.test(specContent)) {
    extra.push({ name: 'isPulsing', type: 'Bool' });
  }

  return [...defaults, ...extra];
}

function extractContentCases(specContent, contract) {
  if (Array.isArray(contract?.contentCases) && contract.contentCases.length > 0) {
    return contract.contentCases.filter(c => typeof c === 'string' && c.trim().length > 0);
  }

  if (!specContent) return [];

  // Look for explicit content model mentions
  const cases = [];
  if (/text.only|label.only|text content/i.test(specContent)) {
    cases.push('text(String)');
  }
  if (/icon|image/i.test(specContent)) {
    cases.push('icon(Image)');
    if (/icon.*text|text.*icon/i.test(specContent)) {
      cases.push('iconText(icon: Image, text: String, placement: Placement)');
    }
  }
  if (/count|number|badge.?count/i.test(specContent)) {
    cases.push('count(Int)');
  }
  if (/dot|indicator/i.test(specContent)) {
    cases.push('dot');
  }

  return cases;
}

// ---------------------------------------------------------------------------
// Template renderer
// ---------------------------------------------------------------------------

function renderTemplate(templateFile, context) {
  const templatePath = path.join(TEMPLATES_DIR, templateFile);
  if (!fs.existsSync(templatePath)) {
    throw new Error(`Template not found: ${templatePath}`);
  }
  const source = fs.readFileSync(templatePath, 'utf8');
  const template = Handlebars.compile(source, { noEscape: true });
  return template(context);
}

// ---------------------------------------------------------------------------
// Output files config
// ---------------------------------------------------------------------------

function getOutputFiles(context) {
  return [
    {
      template: 'CatComponentStyle.swift.hbs',
      outputName: `Cat${context.PascalName}Style.swift`,
      description: 'State machine types + ViewModifier',
      destination: `iOS/Catalyst/Sources/Catalyst/Components/${context.PascalName}s/`,
    },
    {
      template: 'CatComponentBuilder.swift.hbs',
      outputName: `Cat${context.PascalName}Builder.swift`,
      description: 'Layout helper + public Cat{Name} view',
      destination: `iOS/Catalyst/Sources/Catalyst/Components/${context.PascalName}s/`,
    },
    {
      template: 'CatTheme+Component.swift.hbs',
      outputName: `CatTheme+${context.PascalName}.swift`,
      description: 'CatTheme extension with component token configs',
      destination: `iOS/Catalyst/Sources/Catalyst/Theme/`,
    },
    {
      template: 'Component.kt.hbs',
      outputName: `${context.PascalName}.kt`,
      description: 'Android Compose skeleton',
      destination: `android/catalyst/src/main/java/com/haiilo/catalyst/components/`,
    },
  ];
}

// ---------------------------------------------------------------------------
// Main
// ---------------------------------------------------------------------------

async function main() {
  console.log(chalk.bold.cyan(`\nCatalyst Scaffold Agent`));
  console.log(chalk.dim(`Component: ${componentKebab} → ${PascalName}\n`));

  const componentOutputDir = path.join(OUTPUT_DIR, componentKebab);
  fs.mkdirSync(componentOutputDir, { recursive: true });

  // Load spec if available
  const specPath = opts.spec ?? path.join(componentOutputDir, 'spec.md');
  let specContent = null;
  let contract = null;
  if (fs.existsSync(specPath)) {
    specContent = fs.readFileSync(specPath, 'utf8');
    contract = parseSpecContract(specContent);
    console.log(chalk.green(`  Loaded spec from ${specPath}`));
    if (contract) {
      console.log(chalk.green(`  Found machine-readable spec contract (v${contract.specVersion ?? 'unknown'})`));
    } else {
      console.log(chalk.yellow(`  No machine-readable contract found — using legacy text parsing`));
    }
  } else {
    console.log(chalk.yellow(`  No spec.md found — scaffolding with defaults`));
    console.log(chalk.dim(`  Tip: run research-agent first, or add a spec.md to ${componentOutputDir}/`));
  }

  // Load token audit if available
  const auditPath = path.join(componentOutputDir, 'token-audit.md');
  if (fs.existsSync(auditPath)) {
    console.log(chalk.green(`  Found token-audit.md — using audit context`));
    const auditContent = fs.readFileSync(auditPath, 'utf8');
    if (auditContent.includes('❌ Missing')) {
      console.log(chalk.yellow(`\n  Warning: token-audit.md shows missing tokens.`));
      console.log(chalk.dim(`  Scaffolding will proceed but generated theme configs may have TODO placeholders.`));
      console.log(chalk.dim(`  Consider requesting missing tokens from the design team first.\n`));
    }
  }

  // Build context
  const context = buildTemplateContext(specContent, contract);
  console.log(chalk.dim(`\nTemplate context:`));
  console.log(chalk.dim(`  PascalName:       ${context.PascalName}`));
  console.log(chalk.dim(`  hasContentEnum:   ${context.hasContentEnum}`));
  console.log(chalk.dim(`  hasBorderVariant: ${context.hasBorderVariant}`));
  console.log(chalk.dim(`  sizes:            ${context.sizes.map(s => s.caseName).join(', ')}`));
  console.log(chalk.dim(`  defaultSize:      ${context.defaultSize}`));

  // Render and write
  const outputFiles = getOutputFiles(context);
  console.log(chalk.dim(`\nGenerating files...\n`));

  const written = [];
  for (const file of outputFiles) {
    try {
      const rendered = renderTemplate(file.template, context);
      const outputPath = path.join(componentOutputDir, file.outputName);
      fs.writeFileSync(outputPath, rendered);
      written.push({ ...file, outputPath });
      console.log(chalk.green(`  ✅ ${file.outputName}`));
      console.log(chalk.dim(`     ${file.description}`));
    } catch (err) {
      console.log(chalk.red(`  ❌ ${file.outputName}: ${err.message}`));
    }
  }

  // Write install manifest (used by review-agent and future install script)
  const manifest = {
    component: componentKebab,
    pascalName: PascalName,
    generatedAt: new Date().toISOString(),
    files: written.map(f => ({
      name: f.outputName,
      stagedPath: f.outputPath,
      targetDir: f.destination,
      description: f.description,
    })),
  };
  fs.writeFileSync(
    path.join(componentOutputDir, 'manifest.json'),
    JSON.stringify(manifest, null, 2)
  );

  // Summary
  console.log(chalk.bold.green(`\nScaffold complete!`));
  console.log(chalk.dim(`\nAll files staged at: ${componentOutputDir}/`));
  console.log(chalk.dim(`\nFiles generated:`));
  for (const f of written) {
    console.log(chalk.cyan(`  ${f.outputName}`));
    console.log(chalk.dim(`    → move to: ${f.destination}`));
  }

  console.log(chalk.bold(`\nNext steps:`));
  console.log(`  1. ${chalk.cyan('Review')} each generated file in ${componentOutputDir}/`);
  console.log(`  2. ${chalk.cyan('Run the review agent')} for an automated code review:`);
  console.log(chalk.dim(`       node review-agent.js --component=${componentKebab}`));
  console.log(`  3. ${chalk.cyan('Manually move')} reviewed files to their target directories (see above)`);
  console.log(`  4. ${chalk.cyan('Open in Xcode/Android Studio')} and resolve any remaining TODO markers`);
  console.log(`  5. ${chalk.cyan('Build the demo app')} to visually verify the component`);
}

main().catch(err => {
  console.error(chalk.red(`\nError: ${err.message}`));
  process.exit(1);
});
