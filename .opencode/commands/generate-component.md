---
description: Scaffold a new Catalyst component from a brief
---

# Generate Catalyst Component — $ARGUMENTS

## Step 1: Read the brief

The contributor has written a brief describing this component. Read it carefully — every decision you make must be grounded in what the brief says. Do not add states, variants, sizes, or complexity that the brief does not mention.

@scripts/agents/output/$ARGUMENTS/brief.md

## Step 2: Load the token vocabulary

!`node --input-type=module << 'EOF'
import { loadAllTokens } from './scripts/tools/token-auditor.js';
const t = loadAllTokens('./tokens/src');
const vocab = { colors: [], spacing: [], sizes: [], borderRadius: [], borderWidth: [], typography: [] };
for (const [k, v] of Object.entries(t)) {
  if (v.type === 'color' && (k.includes('theme') || k.includes('ui'))) vocab.colors.push(k);
  else if (v.type === 'spacing') vocab.spacing.push(k);
  else if (v.type === 'sizing') vocab.sizes.push(k);
  else if (v.type === 'borderRadius') vocab.borderRadius.push(k);
  else if (v.type === 'borderWidth') vocab.borderWidth.push(k);
  else if (v.type === 'typography') vocab.typography.push(k);
}
console.log(JSON.stringify(vocab, null, 2));
EOF`

These are the only token paths you may reference. Do not invent paths that are not in this output.

## Step 3: Reference components (pattern reference only — do not modify)

### iOS — Interactive pattern
@iOS/Catalyst/Sources/Catalyst/Components/Buttons/CatButtonStyle.swift
@iOS/Catalyst/Sources/Catalyst/Components/Buttons/CatButtonBuilder.swift
@iOS/Catalyst/Sources/Catalyst/Theme/CatTheme+Button.swift
@iOS/Catalyst/Sources/Catalyst/Components/SegmentedControl/CatSegmentedControlStyle.swift
@iOS/Catalyst/Sources/Catalyst/Components/SegmentedControl/CatSegmentedControlBuilder.swift
@iOS/Catalyst/Sources/Catalyst/Theme/CatTheme+SegmentedControl.swift

### iOS — Display pattern
@iOS/Catalyst/Sources/Catalyst/Components/Alert/CatAlertStyle.swift
@iOS/Catalyst/Sources/Catalyst/Components/Alert/CatAlertBuilder.swift
@iOS/Catalyst/Sources/Catalyst/Theme/CatTheme+Alert.swift

### Android — Interactive pattern
@android/catalyst/src/main/java/com/haiilo/catalyst/components/buttons/CatButton.kt
@android/catalyst/src/main/java/com/haiilo/catalyst/components/buttons/CatButtonEnums.kt
@android/catalyst/src/main/java/com/haiilo/catalyst/components/buttons/CatButtonStateStyle.kt
@android/catalyst/src/main/java/com/haiilo/catalyst/components/buttons/CatButtonDefaults.kt
@android/catalyst/src/main/java/com/haiilo/catalyst/components/segmentedcontrol/CatSegmentedControl.kt
@android/catalyst/src/main/java/com/haiilo/catalyst/components/segmentedcontrol/CatSegmentedControlEnums.kt
@android/catalyst/src/main/java/com/haiilo/catalyst/components/segmentedcontrol/CatSegmentedControlDefaults.kt

### Android — Display pattern
@android/catalyst/src/main/java/com/haiilo/catalyst/components/alerts/CatAlert.kt
@android/catalyst/src/main/java/com/haiilo/catalyst/components/alerts/CatAlertDefaults.kt

## Step 4: Produce decisions.json

Based on the brief and token vocabulary, decide exactly what this component needs. Apply these rules:

**Profile:**
- `display` — not tappable, purely visual
- `interactive` — tappable, has press/focus behaviour

**States:**
- `display`: `["normal", "disabled"]` only, unless brief explicitly requires more
- `interactive`: `["normal", "pressed", "focused", "disabled"]` always; add `hovered` only if brief mentions hover; add `loading` only if brief mentions async/loading

**Variants:** only if brief names distinct color/visual options

**Sizes:** only if brief names distinct size presets

**Content model:**
- `label` — single text string
- `enum` — two or more structurally different content types

**hasAccentPaletteSupport:** true only if component has a primary or brand color variant

**Android file plan:**
- `interactive`: include `Enums` if hasVariants OR hasSizes OR contentModel=enum; always include `StateStyle`, `Defaults`, `Config`, `Composable`
- `display`: include `Enums` only if hasVariants; always include `Colors`, `Defaults`, `Config`, `Composable`

**iOS file plan:** always `["Style", "Builder", "Theme"]`

Write `scripts/agents/output/$ARGUMENTS/decisions.json` with this exact schema:

```json
{
  "component": "$ARGUMENTS",
  "profile": "display",
  "states": ["normal", "disabled"],
  "hasVariants": true,
  "variants": ["Primary"],
  "hasSizes": false,
  "sizes": [],
  "contentModel": "label",
  "contentCases": [],
  "hasAccentPaletteSupport": true,
  "iosFilePlan": ["Style", "Builder", "Theme"],
  "androidFilePlan": ["Enums", "Colors", "Defaults", "Config", "Composable"],
  "tokenRequirements": [
    { "property": "primary background", "tokenPath": "color.theme.primary.bg" }
  ],
  "reasoning": "2-4 sentences explaining key decisions made from the brief."
}
```

## Step 5: Audit tokens

!`node --input-type=module << 'EOF'
import { loadAllTokens, auditTokens, formatAuditReport } from './scripts/tools/token-auditor.js';
import fs from 'fs';
const decisionsPath = 'scripts/agents/output/$ARGUMENTS/decisions.json';
const d = JSON.parse(fs.readFileSync(decisionsPath, 'utf8'));
const tokens = loadAllTokens('./tokens/src');
const result = auditTokens(d.tokenRequirements ?? [], tokens);
const report = formatAuditReport(result, '$ARGUMENTS');
fs.writeFileSync('scripts/agents/output/$ARGUMENTS/token-audit.md', report, 'utf8');
console.log(JSON.stringify({
  resolved: result.resolved.length,
  fuzzy: result.fuzzy.length,
  ambiguous: result.ambiguous.length,
  missing: result.missing
}));
EOF`

If the output contains any `missing` entries, **stop here**. Do not proceed to scaffolding. Tell the contributor:
- Which tokens are missing
- They must not add tokens manually — tokens come from Figma via the design team
- To update brief.md if a different existing token should be used instead
- To re-run `/generate-component $ARGUMENTS` once tokens are resolved

## Step 6: Scaffold

!`node scripts/tools/scaffolder.js --component=$ARGUMENTS --decisions=scripts/agents/output/$ARGUMENTS/decisions.json`

The scaffolder outputs JSON listing generated files. Report these to the contributor.

## Step 7: Review generated files

Read all `.swift` and `.kt` files in `scripts/agents/output/$ARGUMENTS/` and verify:

1. No hardcoded hex values — all colors via `CatColors.*`, spacing via `CatSpacing.*`, etc.
2. All public types have the `Cat` prefix
3. No type named `Default` or other reserved words
4. State priority order: `disabled → loading → pressed → hovered (iOS only) → focused → normal`
5. No hardcoded `accessibilityLabel` — consuming view must set these
6. Nothing added beyond what the brief describes
7. Interactive profile matches CatButton pattern; display matches CatAlert pattern
8. Android tokens use snake_case (`border_radius_md` not `borderRadiusMd`)
9. Android composables use `Box + clip + background`, not Material3 `Surface`

Write findings to `scripts/agents/output/$ARGUMENTS/review.md`.

## Step 8: Parity check

Compare the generated `.swift` and `.kt` files and verify:

1. Same variants on both platforms
2. Same states — iOS having `hovered` with no Android equivalent is expected and not an issue
3. Content model maps to equivalent use cases
4. Token references are semantically equivalent across platforms
5. Environment/CompositionLocal config wiring follows the same pattern on both

Write findings to `scripts/agents/output/$ARGUMENTS/parity.md`.

## Step 9: Summary

Give the contributor:
- List of generated files
- Any blocking review issues
- Any parity issues
- Clear next steps

**Move to source once clean:**
- iOS: `iOS/Catalyst/Sources/Catalyst/Components/<PascalName>s/`
- Android: `android/catalyst/src/main/java/com/haiilo/catalyst/components/$ARGUMENTS/`

**After moving to source:**
1. Add to Demo app and verify it renders correctly
2. Create Jira tasks for iOS and Android labelled `catalyst-mobile`
3. Write `docs/ios/$ARGUMENTS.md` and `docs/android/$ARGUMENTS.md`
4. Open PR — branch: `feat/$ARGUMENTS-component`, commit: `feat($ARGUMENTS): add Cat<Name> component`
5. Requires `@coyoapp/mobile-design-core` review
