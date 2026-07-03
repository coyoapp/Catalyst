[← Back to README](../../README.md)

# CatSegmentedControl — Android

`CatSegmentedControl` is a single-select segmented control for the Catalyst Android design system. For v1, the recommended usage is a **2-option, full-width, text-only control** like “Option 1 / Option 2” or “Enabled / Paused”.

The implementation remains generic underneath, so the component can grow later without changing its foundation, but the primary public guidance intentionally stays narrow for the first release.

---

## Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `items` | `List<CatSegmentedControlItem<T>>` | required on the generic overload | Segments shown from start to end |
| `firstItem` / `secondItem` | `CatSegmentedControlItem<T>` | required on the 2-option overload | Recommended v1 API for the common binary-control case |
| `selectedValue` | `T?` | required | Currently selected value. Pass `null` for an initially unselected state |
| `onSelectionChange` | `(T) -> Unit` | required | Called when the user chooses a different segment |
| `modifier` | `Modifier` | `Modifier` | Applied to the outer container |
| `color` | `CatSegmentedControlColor` | `Primary` | Semantic color role used by the selected segment |
| `size` | `CatSegmentedControlSize` | `Medium` | Controls the overall height and segment padding |
| `enabled` | `Boolean` | `true` | Parent enabled state for the whole control |
| `equalWidth` | `Boolean` | `true` on the generic overload | When `true`, segments share the same width |
| `style` | `CatSegmentedControlColors?` | `null` | Advanced escape hatch. Prefer `color` and tokens for standard usage |

---

## Color roles

| Color | Usage |
|-------|-------|
| `Primary` | Default selection / brand accent |
| `Secondary` | Neutral secondary selection |
| `Danger` | Destructive or critical filters |
| `Success` | Positive states |
| `Warning` | Warning-related modes |
| `Info` | Informational modes |
| `PrimaryInverted` / `SecondaryInverted` | Use when the selected state needs to read on dark surfaces |

---

## Size

`CatSegmentedControlSize` mirrors the button size scale so segmented controls align cleanly with buttons.

| Size | Height | Horizontal padding per segment |
|------|--------|--------------------------------|
| `XSmall` | 32 dp | 8 dp |
| `Small` | 40 dp | 16 dp |
| `Medium` *(default)* | 48 dp | 16 dp |
| `Custom(height, horizontalPadding)` | caller-supplied | caller-supplied |

---

## Recommended v1 pattern

Use the dedicated 2-option overload for most first-iteration product cases.

```kotlin
var selectedValue by remember { mutableStateOf("Option 1") }

CatSegmentedControl(
    modifier = Modifier.fillMaxWidth(),
    firstItem = CatSegmentedControlItem("Option 1", CatSegmentedControlContent.TextOnly("Option 1")),
    secondItem = CatSegmentedControlItem("Option 2", CatSegmentedControlContent.TextOnly("Option 2")),
    selectedValue = selectedValue,
    onSelectionChange = { selectedValue = it },
)
```

This matches the intended v1 shape best:

- 2 options
- equal width
- full width
- text only
- single selected pill
- outer container height is 48 dp with 4 dp inset on all sides
- each inner segment resolves to 40 dp height in the default small size
- outer holder uses a muted background without a visible border by default
- selected segment uses a white surface with semantic text color
- unselected segment sits on the muted gray container with muted text
- disabled segments use the muted filled background with muted text, matching the shared disabled treatment used by Catalyst buttons
- selected label uses the semibold `CatTypography.button1` style
- unselected label uses the regular `CatTypography.button2` style

---

## Basic usage

```kotlin
var selectedValue by remember { mutableStateOf("Enabled") }

CatSegmentedControl(
    modifier = Modifier.fillMaxWidth(),
    firstItem = CatSegmentedControlItem("Enabled", CatSegmentedControlContent.TextOnly("Enabled")),
    secondItem = CatSegmentedControlItem("Paused", CatSegmentedControlContent.TextOnly("Paused")),
    selectedValue = selectedValue,
    onSelectionChange = { selectedValue = it },
    color = CatSegmentedControlColor.Primary,
)
```

---

## Content

`CatSegmentedControlItem<T>` wraps the stable value and visible content for a segment:

```kotlin
data class CatSegmentedControlItem<T>(
    val value: T,
    val content: CatSegmentedControlContent,
    val enabled: Boolean = true,
)
```

For v1, prefer `TextOnly`.

The underlying API also supports icon-based content types, but those are intentionally deferred from the primary guidance until there is a concrete product need.

`CatSegmentedControlContent` supports three display modes:

| Case | Description |
|------|-------------|
| `TextOnly(text: String)` | Text label only |
| `IconOnly(painter: Painter, contentDescription: String?)` | Icon only *(supported, not part of the primary v1 recommendation)* |
| `IconText(painter: Painter, text: String, placement: CatSegmentedControlPlacement, iconContentDescription: String?)` | Icon and text side by side *(supported, but deferred from the main v1 pattern)* |

---

## Disabled item

Disable an individual segment without disabling the whole control:

```kotlin
CatSegmentedControl(
    modifier = Modifier.fillMaxWidth(),
    firstItem = CatSegmentedControlItem("Upcoming", CatSegmentedControlContent.TextOnly("Upcoming")),
    secondItem = CatSegmentedControlItem(
        value = "Archived",
        content = CatSegmentedControlContent.TextOnly("Archived"),
        enabled = false,
    ),
    selectedValue = selectedValue,
    onSelectionChange = { selectedValue = it },
)
```

---

## Accent color

Like `CatButton` and `CatAlert`, Catalyst supports a brand accent color that overrides the default `Primary` palette.

### App-wide setup

```kotlin
CatThemeConfig.configure("#1A73E8")
```

### Per-subtree override

```kotlin
ProvideAccentColor(Color(0xFFE8340A)) {
    CatSegmentedControl(
        modifier = Modifier.fillMaxWidth(),
        firstItem = CatSegmentedControlItem("Enabled", CatSegmentedControlContent.TextOnly("Enabled")),
        secondItem = CatSegmentedControlItem("Paused", CatSegmentedControlContent.TextOnly("Paused")),
        selectedValue = selectedValue,
        onSelectionChange = { selectedValue = it },
        color = CatSegmentedControlColor.Primary,
    )
}
```

---

## More than two options

The underlying implementation still supports more than two segments through the generic `items` overload.

That capability is intentionally not the primary documented v1 pattern, because the current design direction is centered on binary controls.

---

## Style override

`style: CatSegmentedControlColors?` is an **escape hatch**, not the normal design-system path.

Use it only when you have a one-off UI requirement that cannot be expressed through:

- the standard semantic `color`
- existing design tokens
- the app-wide or subtree accent color

Why this is de-emphasized:

- it bypasses the shared token mapping
- it makes consistency across products harder
- it can drift away from the design system if overused

For most product work, prefer the standard props and token-driven defaults.

---

## Accessibility

- The control uses single-select semantics via `selectableGroup` and per-segment `Role.RadioButton`
- Text and icon semantics are merged into the segment for discoverability without test tags
- For icon-only segments, provide a meaningful `contentDescription`

