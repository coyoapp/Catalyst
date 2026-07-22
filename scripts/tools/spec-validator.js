/**
 * spec-validator.js
 *
 * Validates the decisions object produced by the LLM agent.
 * Pure function — no file I/O, no LLM.
 *
 * Usage (from agent):
 *   import { validateDecisions } from '../tools/spec-validator.js';
 *   const { valid, errors } = validateDecisions(decisionsObj);
 */

const ALLOWED_PROFILES = new Set(['interactive', 'display']);
const ALLOWED_STATES = new Set(['normal', 'hovered', 'pressed', 'focused', 'disabled', 'loading']);
const ALLOWED_CONTENT_MODELS = new Set(['label', 'enum']);

const IOS_FILE_OPTIONS = new Set(['Style', 'Builder', 'Theme']);
const ANDROID_FILE_OPTIONS = new Set(['Enums', 'StateStyle', 'Colors', 'Defaults', 'Config', 'Composable']);

/**
 * Validates a decisions object returned by the LLM.
 *
 * @param {object} decisions
 * @returns {{ valid: boolean, errors: string[], warnings: string[] }}
 */
function validateDecisions(decisions) {
  const errors = [];
  const warnings = [];

  if (!decisions || typeof decisions !== 'object') {
    return { valid: false, errors: ['decisions must be an object'], warnings: [] };
  }

  // profile
  if (!ALLOWED_PROFILES.has(decisions.profile)) {
    errors.push(`profile must be "interactive" or "display", got: "${decisions.profile}"`);
  }

  // states
  if (!Array.isArray(decisions.states) || decisions.states.length === 0) {
    errors.push('states must be a non-empty array');
  } else {
    for (const s of decisions.states) {
      if (!ALLOWED_STATES.has(s)) errors.push(`unknown state: "${s}"`);
    }
    if (!decisions.states.includes('normal')) errors.push('states must include "normal"');
    if (!decisions.states.includes('disabled')) errors.push('states must include "disabled"');

    if (decisions.profile === 'display') {
      if (decisions.states.includes('pressed')) {
        warnings.push('display profile has "pressed" state — confirm component is tappable');
      }
      if (decisions.states.includes('hovered')) {
        warnings.push('display profile has "hovered" state — hovered is iOS-only and unusual for display components');
      }
    }

    if (decisions.profile === 'interactive') {
      if (!decisions.states.includes('pressed')) {
        warnings.push('interactive profile missing "pressed" state');
      }
      if (!decisions.states.includes('focused')) {
        warnings.push('interactive profile missing "focused" state');
      }
    }
  }

  // variants
  if (typeof decisions.hasVariants !== 'boolean') {
    errors.push('hasVariants must be a boolean');
  }
  if (decisions.hasVariants) {
    if (!Array.isArray(decisions.variants) || decisions.variants.length === 0) {
      errors.push('variants must be a non-empty array when hasVariants is true');
    }
  }

  // sizes
  if (typeof decisions.hasSizes !== 'boolean') {
    errors.push('hasSizes must be a boolean');
  }
  if (decisions.hasSizes) {
    if (!Array.isArray(decisions.sizes) || decisions.sizes.length === 0) {
      errors.push('sizes must be a non-empty array when hasSizes is true');
    } else {
      for (const size of decisions.sizes) {
        if (!size.name) errors.push('each size must have a name');
        if (!size.heightToken) warnings.push(`size "${size.name}" is missing heightToken`);
      }
    }
  }

  // content model
  if (!ALLOWED_CONTENT_MODELS.has(decisions.contentModel)) {
    errors.push(`contentModel must be "label" or "enum", got: "${decisions.contentModel}"`);
  }
  if (decisions.contentModel === 'enum') {
    if (!Array.isArray(decisions.contentCases) || decisions.contentCases.length === 0) {
      errors.push('contentCases must be a non-empty array when contentModel is "enum"');
    }
  }

  // accent palette
  if (typeof decisions.hasAccentPaletteSupport !== 'boolean') {
    warnings.push('hasAccentPaletteSupport not specified — defaulting to false');
  }

  // file plans
  if (!Array.isArray(decisions.iosFilePlan) || decisions.iosFilePlan.length === 0) {
    errors.push('iosFilePlan must be a non-empty array');
  } else {
    for (const f of decisions.iosFilePlan) {
      if (!IOS_FILE_OPTIONS.has(f)) errors.push(`unknown iOS file: "${f}" — allowed: ${[...IOS_FILE_OPTIONS].join(', ')}`);
    }
    if (!decisions.iosFilePlan.includes('Style')) errors.push('iosFilePlan must include "Style"');
    if (!decisions.iosFilePlan.includes('Builder')) errors.push('iosFilePlan must include "Builder"');
    if (!decisions.iosFilePlan.includes('Theme')) errors.push('iosFilePlan must include "Theme"');
  }

  if (!Array.isArray(decisions.androidFilePlan) || decisions.androidFilePlan.length === 0) {
    errors.push('androidFilePlan must be a non-empty array');
  } else {
    for (const f of decisions.androidFilePlan) {
      if (!ANDROID_FILE_OPTIONS.has(f)) errors.push(`unknown Android file: "${f}" — allowed: ${[...ANDROID_FILE_OPTIONS].join(', ')}`);
    }
    if (!decisions.androidFilePlan.includes('Composable')) errors.push('androidFilePlan must include "Composable"');
    if (!decisions.androidFilePlan.includes('Defaults')) errors.push('androidFilePlan must include "Defaults"');
  }

  // token requirements
  if (!Array.isArray(decisions.tokenRequirements)) {
    warnings.push('tokenRequirements is missing or not an array — token audit will be skipped');
  }

  // reasoning
  if (typeof decisions.reasoning !== 'string' || decisions.reasoning.trim().length < 20) {
    warnings.push('reasoning is missing or too short — contributor will have limited insight into agent decisions');
  }

  return {
    valid: errors.length === 0,
    errors,
    warnings,
  };
}

export { validateDecisions };
