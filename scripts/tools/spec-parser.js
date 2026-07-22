/**
 * spec-parser.js
 *
 * Shared token-path utilities used across tools and the agent.
 * Pure functions — no file I/O, no LLM, no side effects.
 */

const SENTINEL_TOKEN_VALUES = new Set(['missing', 'none', 'n/a', 'na', '-', '']);

function looksLikeTokenPath(value) {
  return /^[a-z][a-z0-9.-]*(\.[a-z0-9.-]+)+$/i.test(value);
}

function normalizeTokenValue(value) {
  return String(value ?? '').trim();
}

function isSentinelTokenValue(value) {
  return SENTINEL_TOKEN_VALUES.has(normalizeTokenValue(value).toLowerCase());
}

function toPascalCase(str) {
  return String(str)
    .split(/[-_\s]+/)
    .filter(Boolean)
    .map(word => word.charAt(0).toUpperCase() + word.slice(1).toLowerCase())
    .join('');
}

function toCamelCase(str) {
  const pascal = toPascalCase(str);
  return pascal.charAt(0).toLowerCase() + pascal.slice(1);
}

/**
 * Maps a dot-path token (e.g. "color.theme.primary.bg") to
 * the Swift CatColors/CatSpacing/etc. accessor used in source.
 */
function mapTokenPathToSwiftAccessor(tokenPath) {
  if (!looksLikeTokenPath(tokenPath)) return null;
  const segments = tokenPath.split('.');
  const root = segments[0].toLowerCase();

  function joinPascal(parts) {
    return parts.map(toPascalCase).join('.');
  }

  if (root === 'color') return `CatColors.${joinPascal(segments.slice(1))}`;
  if (root === 'spacing') return `CatSpacing.${toPascalCase(segments[1] ?? '')}`;
  if (root === 'size') return `CatSizes.${toPascalCase(segments[1] ?? '')}`;
  if (root === 'border-radius') return `CatBorderRadius.${toPascalCase(segments[1] ?? '')}`;
  if (root === 'border-width') return `CatBorderWidth.${toPascalCase(segments[1] ?? '')}`;
  if (root === 'typography') return `CatTypography.${toPascalCase(segments[1] ?? '')}`;
  return null;
}

/**
 * Maps a dot-path token to the Kotlin/Android accessor (snake_case).
 * e.g. "color.theme.primary.bg" → "CatColors.Theme.Primary.bg"
 * e.g. "border-radius.md" → "CatBorderRadius.border_radius_md"
 */
function mapTokenPathToKotlinAccessor(tokenPath) {
  if (!looksLikeTokenPath(tokenPath)) return null;
  const segments = tokenPath.split('.');
  const root = segments[0].toLowerCase();

  function toSnake(str) {
    return str.replace(/-/g, '_').toLowerCase();
  }

  if (root === 'color') {
    // color.theme.primary.bg → CatColors.Theme.Primary.bg
    return `CatColors.${segments.slice(1).map((s, i) =>
      i < segments.length - 2 ? toPascalCase(s) : s
    ).join('.')}`;
  }
  if (root === 'spacing') return `CatSpacing.spacing_${toSnake(segments[1] ?? '')}`;
  if (root === 'size') return `CatSizes.size_${toSnake(segments[1] ?? '')}`;
  if (root === 'border-radius') return `CatBorderRadius.border_radius_${toSnake(segments[1] ?? '')}`;
  if (root === 'border-width') return `CatBorderWidth.border_width_${toSnake(segments[1] ?? '')}`;
  if (root === 'typography') return `CatTypography.${toSnake(segments[1] ?? '')}`;
  return null;
}

export {
  SENTINEL_TOKEN_VALUES,
  looksLikeTokenPath,
  normalizeTokenValue,
  isSentinelTokenValue,
  toPascalCase,
  toCamelCase,
  mapTokenPathToSwiftAccessor,
  mapTokenPathToKotlinAccessor,
};
