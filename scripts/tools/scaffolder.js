/**
 * scaffolder.js
 *
 * Renders Handlebars templates into output/{component}/ based on the
 * decisions object produced by the LLM agent.
 *
 * Pure function (given decisions + output dir) — no LLM.
 * Selects only the templates needed per the decisions.iosFilePlan
 * and decisions.androidFilePlan.
 *
 * Usage (from agent):
 *   import { scaffold } from '../tools/scaffolder.js';
 *   const written = await scaffold(decisions, outputDir);
 */

import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';
import Handlebars from 'handlebars';
import { toPascalCase, toCamelCase } from './spec-parser.js';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const TEMPLATES_DIR = path.join(__dirname, '..', 'templates');

// ---------------------------------------------------------------------------
// Handlebars helpers
// ---------------------------------------------------------------------------

Handlebars.registerHelper('toUpperCase', str => String(str).toUpperCase());
Handlebars.registerHelper('toPascalCase', str => toPascalCase(String(str)));
Handlebars.registerHelper('toCamelCase', str => toCamelCase(String(str)));
Handlebars.registerHelper('eq', (a, b) => a === b);

// ---------------------------------------------------------------------------
// Template loader
// ---------------------------------------------------------------------------

function loadTemplate(templateFile) {
  const templatePath = path.join(TEMPLATES_DIR, templateFile);
  if (!fs.existsSync(templatePath)) {
    throw new Error(`Template not found: ${templateFile}`);
  }
  return Handlebars.compile(fs.readFileSync(templatePath, 'utf8'));
}

// ---------------------------------------------------------------------------
// Template context builder
// ---------------------------------------------------------------------------

function buildTemplateContext(decisions) {
  const PascalName = toPascalCase(decisions.component);
  const camelName = toCamelCase(decisions.component);
  const date = new Date().toISOString().split('T')[0];

  const firstContentCase = decisions.contentModel === 'enum' && decisions.contentCases?.length > 0
    ? decisions.contentCases[0]
    : null;

  const firstVariant = decisions.hasVariants && decisions.variants?.length > 0
    ? decisions.variants[0]
    : 'Primary';

  return {
    PascalName,
    camelName,
    date,
    component: decisions.component,
    profile: decisions.profile,
    isInteractive: decisions.profile === 'interactive',
    isDisplay: decisions.profile === 'display',
    states: decisions.states ?? ['normal', 'disabled'],
    hasHovered: (decisions.states ?? []).includes('hovered'),
    hasLoading: (decisions.states ?? []).includes('loading'),
    hasPressed: (decisions.states ?? []).includes('pressed'),
    hasFocused: (decisions.states ?? []).includes('focused'),
    hasVariants: decisions.hasVariants ?? false,
    variants: decisions.variants ?? [],
    firstVariant,
    hasSizes: decisions.hasSizes ?? false,
    sizes: decisions.sizes ?? [],
    defaultSize: decisions.sizes?.[0]?.name ?? 'medium',
    hasContentEnum: decisions.contentModel === 'enum',
    contentCases: decisions.contentCases ?? [],
    firstContentCase,
    hasAccentPaletteSupport: decisions.hasAccentPaletteSupport ?? false,
  };
}

// ---------------------------------------------------------------------------
// Template map
// Template names are keyed by [platform]-[filePlanEntry]-[profile]
// ---------------------------------------------------------------------------

const TEMPLATE_MAP = {
  // iOS interactive
  'ios-Style-interactive':   'ios/CatComponentStyle.swift.hbs',
  'ios-Builder-interactive': 'ios/CatComponentBuilder.swift.hbs',
  'ios-Theme-interactive':   'ios/CatTheme+Component.swift.hbs',
  // iOS display
  'ios-Style-display':       'ios/CatComponentStyleDisplay.swift.hbs',
  'ios-Builder-display':     'ios/CatComponentBuilderDisplay.swift.hbs',
  'ios-Theme-display':       'ios/CatTheme+ComponentDisplay.swift.hbs',
  // Android interactive
  'android-Enums-interactive':      'android/CatComponentEnums.kt.hbs',
  'android-StateStyle-interactive': 'android/CatComponentStateStyle.kt.hbs',
  'android-Defaults-interactive':   'android/CatComponentDefaults.kt.hbs',
  'android-Config-interactive':     'android/CatComponentConfig.kt.hbs',
  'android-Composable-interactive': 'android/CatComponent.kt.hbs',
  // Android display
  'android-Enums-display':      'android/CatComponentEnums.kt.hbs',      // same — just color enum
  'android-Colors-display':     'android/CatComponentColors.kt.hbs',
  'android-Defaults-display':   'android/CatComponentDefaultsDisplay.kt.hbs',
  'android-Config-display':     'android/CatComponentConfig.kt.hbs',      // same structure
  'android-Composable-display': 'android/CatComponentDisplay.kt.hbs',
};

// Output file name generators
function iosOutputName(PascalName, fileEntry, profile) {
  switch (fileEntry) {
    case 'Style':   return profile === 'display'
      ? `Cat${PascalName}StyleConfig.swift`
      : `Cat${PascalName}Style.swift`;
    case 'Builder': return `Cat${PascalName}Builder.swift`;
    case 'Theme':   return `CatTheme+${PascalName}.swift`;
    default: return `Cat${PascalName}_${fileEntry}.swift`;
  }
}

function androidOutputName(PascalName, fileEntry, profile) {
  switch (fileEntry) {
    case 'Enums':      return `Cat${PascalName}Enums.kt`;
    case 'StateStyle': return `Cat${PascalName}StateStyle.kt`;
    case 'Colors':     return `Cat${PascalName}Colors.kt`;
    case 'Defaults':   return `Cat${PascalName}Defaults.kt`;
    case 'Config':     return `Cat${PascalName}Config.kt`;
    case 'Composable': return `Cat${PascalName}.kt`;
    default: return `Cat${PascalName}_${fileEntry}.kt`;
  }
}

// ---------------------------------------------------------------------------
// Main scaffold function
// ---------------------------------------------------------------------------

/**
 * Renders all templates based on the decisions object and writes them
 * to the output directory.
 *
 * @param {object} decisions - The validated decisions object from the LLM
 * @param {string} outputDir - Path to output/{component}/
 * @returns {string[]} - List of written file paths
 */
async function scaffold(decisions, outputDir) {
  fs.mkdirSync(outputDir, { recursive: true });

  const ctx = buildTemplateContext(decisions);
  const { PascalName, profile } = ctx;
  const written = [];

  // iOS files
  for (const fileEntry of (decisions.iosFilePlan ?? ['Style', 'Builder', 'Theme'])) {
    const templateKey = `ios-${fileEntry}-${profile}`;
    const templateFile = TEMPLATE_MAP[templateKey];
    if (!templateFile) {
      console.warn(`  [scaffold] No template for key: ${templateKey}`);
      continue;
    }
    const template = loadTemplate(templateFile);
    const content = template(ctx);
    const outFile = path.join(outputDir, iosOutputName(PascalName, fileEntry, profile));
    fs.writeFileSync(outFile, content, 'utf8');
    written.push(outFile);
  }

  // Android files
  for (const fileEntry of (decisions.androidFilePlan ?? [])) {
    const templateKey = `android-${fileEntry}-${profile}`;
    const templateFile = TEMPLATE_MAP[templateKey];
    if (!templateFile) {
      console.warn(`  [scaffold] No template for key: ${templateKey}`);
      continue;
    }
    const template = loadTemplate(templateFile);
    const content = template(ctx);
    const outFile = path.join(outputDir, androidOutputName(PascalName, fileEntry, profile));
    fs.writeFileSync(outFile, content, 'utf8');
    written.push(outFile);
  }

  return written;
}

export { scaffold, buildTemplateContext };

// ---------------------------------------------------------------------------
// CLI entry point
// Called by the OpenCode command after it has written decisions.json:
//   node scripts/tools/scaffolder.js --component=badge --decisions=path/to/decisions.json
// ---------------------------------------------------------------------------

// Only run as CLI when this file is the entry point
if (process.argv[1] && fileURLToPath(import.meta.url) === path.resolve(process.argv[1])) {
  const args = process.argv.slice(2);

  function getArg(name) {
    const flag = args.find(a => a.startsWith(`--${name}=`));
    return flag ? flag.split('=').slice(1).join('=') : null;
  }

  const decisionsPath = getArg('decisions');
  const componentName = getArg('component');

  if (!decisionsPath || !componentName) {
    console.error('Usage: node scaffolder.js --component=<name> --decisions=<path/to/decisions.json>');
    process.exit(1);
  }

  if (!fs.existsSync(decisionsPath)) {
    console.error(`decisions.json not found at: ${decisionsPath}`);
    process.exit(1);
  }

  let decisions;
  try {
    decisions = JSON.parse(fs.readFileSync(decisionsPath, 'utf8'));
  } catch {
    console.error(`Failed to parse decisions.json at: ${decisionsPath}`);
    process.exit(1);
  }

  const outputDir = path.dirname(decisionsPath);

  scaffold(decisions, outputDir)
    .then(written => {
      console.log(JSON.stringify({ success: true, files: written.map(f => path.basename(f)) }));
    })
    .catch(err => {
      console.error(JSON.stringify({ success: false, error: err.message }));
      process.exit(1);
    });
}
