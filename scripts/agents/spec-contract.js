import path from 'path';

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

function extractJsonCodeBlocks(specContent) {
  const blocks = [];
  const re = /```json\s*([\s\S]*?)```/gi;
  let match;
  while ((match = re.exec(specContent)) !== null) {
    blocks.push(match[1].trim());
  }
  return blocks;
}

function parseSpecContract(specContent) {
  const blocks = extractJsonCodeBlocks(specContent);
  for (const block of blocks) {
    try {
      const parsed = JSON.parse(block);
      if (parsed && typeof parsed === 'object' && ('specVersion' in parsed || 'component' in parsed)) {
        return parsed;
      }
    } catch {
      // Ignore non-contract json blocks and continue searching.
    }
  }
  return null;
}

function toPascalCase(str) {
  return String(str)
    .split(/[-_\s]+/)
    .filter(Boolean)
    .map(word => word.charAt(0).toUpperCase() + word.slice(1).toLowerCase())
    .join('');
}

function collectContractTokenRequirements(contract) {
  const requirements = [];
  if (!contract || typeof contract !== 'object') return requirements;

  function pushToken(pathValue, property, notes = '', source = 'contract') {
    const tokenPath = normalizeTokenValue(pathValue);
    if (!tokenPath || isSentinelTokenValue(tokenPath)) return;
    requirements.push({ source, path: tokenPath, property, notes });
  }

  const sizes = Array.isArray(contract.sizes) ? contract.sizes : [];
  for (const size of sizes) {
    if (!size || typeof size !== 'object') continue;
    const sizeName = size.name ?? 'size';
    pushToken(size.heightToken, `Size ${sizeName} height`);
    pushToken(size.horizontalPaddingToken, `Size ${sizeName} horizontal padding`);
    pushToken(size.verticalPaddingToken, `Size ${sizeName} vertical padding`);
    pushToken(size.fontToken, `Size ${sizeName} font`);
  }

  const sharedTokens = contract.sharedTokens && typeof contract.sharedTokens === 'object'
    ? contract.sharedTokens
    : {};
  for (const [name, tokenPath] of Object.entries(sharedTokens)) {
    pushToken(tokenPath, `Shared ${name}`);
  }

  const variants = Array.isArray(contract.variants) ? contract.variants : [];
  for (const variant of variants) {
    if (!variant || typeof variant !== 'object') continue;
    const variantName = variant.name ?? 'variant';

    const stateTokens = variant.stateTokens && typeof variant.stateTokens === 'object'
      ? variant.stateTokens
      : {};

    for (const [stateName, stateConfig] of Object.entries(stateTokens)) {
      if (!stateConfig || typeof stateConfig !== 'object') continue;
      pushToken(stateConfig.background, `${variantName}.${stateName}.background`);
      pushToken(stateConfig.foreground, `${variantName}.${stateName}.foreground`);
      pushToken(stateConfig.border, `${variantName}.${stateName}.border`);
      pushToken(stateConfig.focusRing, `${variantName}.${stateName}.focusRing`);
    }
  }

  const missingTokens = Array.isArray(contract.missingTokens) ? contract.missingTokens : [];
  for (const tokenPath of missingTokens) {
    const normalized = normalizeTokenValue(tokenPath);
    if (!normalized) continue;
    requirements.push({
      source: 'contract-missing',
      path: normalized,
      property: normalized,
      notes: 'Declared missing in contract',
    });
  }

  const seen = new Set();
  return requirements.filter(req => {
    if (seen.has(req.path)) return false;
    seen.add(req.path);
    return true;
  });
}

function mapTokenPathToSwiftAccessor(tokenPath) {
  if (!looksLikeTokenPath(tokenPath)) return null;

  const segments = tokenPath.split('.');
  const root = segments[0].toLowerCase();

  function joinPascal(parts) {
    return parts.map(toPascalCase).join('.');
  }

  if (root === 'color') {
    return `CatColors.${joinPascal(segments.slice(1))}`;
  }
  if (root === 'spacing') {
    return `CatSpacing.${toPascalCase(segments[1] ?? '')}`;
  }
  if (root === 'size') {
    return `CatSizes.${toPascalCase(segments[1] ?? '')}`;
  }
  if (root === 'border-radius') {
    return `CatBorderRadius.${toPascalCase(segments[1] ?? '')}`;
  }
  if (root === 'border-width') {
    return `CatBorderWidth.${toPascalCase(segments[1] ?? '')}`;
  }
  if (root === 'typography') {
    return `CatTypography.${toPascalCase(segments[1] ?? '')}`;
  }

  return null;
}

function defaultSpecPath(outputDir, component) {
  return path.join(outputDir, component, 'spec.md');
}

export {
  SENTINEL_TOKEN_VALUES,
  looksLikeTokenPath,
  normalizeTokenValue,
  isSentinelTokenValue,
  parseSpecContract,
  collectContractTokenRequirements,
  mapTokenPathToSwiftAccessor,
  toPascalCase,
  defaultSpecPath,
};
