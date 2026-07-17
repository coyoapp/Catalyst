[← Back to README](../../README.md)

# CatSegmentedControl — Android

`CatSegmentedControl` is a single-select segmented control for the Catalyst Android design system.

The primary API is the richer item-based overload that supports:

- text-only segments
- icon-only segments
- icon + text segments
- per-item enabled state
- semantic color roles
- size presets
- app-wide and subtree accent color overrides

There is also a text-only convenience overload that accepts `List<String>` and uses index-based selection for simpler cases.

---

## Parameters

### Item-based API

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `items` | `List<CatSegmentedControlItem<T>>` | required | Segments rendered from start to end |
| `selectedValue` | `T?` | required | Currently selected value. Pass `null` for an initially unselected state |
| `onSelectionChange` | `(T) -> Unit` | required | Called when the user chooses a different segment |
| `modifier` | `Modifier` | `Modifier` | Applied to the outer container |
| `color` | `CatSegmentedControlColor` | `Primary` | Semantic color role used by the selected segment |
| `size` | `CatSegmentedControlSize` | `Medium` | Controls the overall height and segment padding |
| `enabled` | `Boolean` | `true` | Parent enabled state for the whole control |
| `equalWidth` | `Boolean` | `true` | When `true`, segments share the same width |
| `style` | `CatSegmentedControlColors?` | `null` | Full color override. When non-null, `color` is ignored for styling |

### Text-only convenience API

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `segments` | `List<String>` | required | Segment titles rendered left to right |
| `selection` | `Int` | required | Index of the selected segment |
| `onSelectionChange` | `(Int) -> Unit` | required | Called when the user chooses a different segment |
| `modifier` | `Modifier` | `Modifier` | Applied to the outer container |
| `color` | `CatSegmentedControlColor` | `Primary` | Semantic color role used by the selected segment |
| `size` | `CatSegmentedControlSize` | `Medium` | Controls the overall height and segment padding |
| `enabled` | `Boolean` | `true` | Parent enabled state for the whole control |
| `style` | `CatSegmentedControlColors?` | `null` | Full color override. When non-null, `color` is ignored for styling |

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

`CatSegmentedControlContent` supports three display modes:

| Case | Description |
|------|-------------|
| `TextOnly(text: String)` | Text label only |
| `IconOnly(painter: Painter, contentDescription: String?)` | Icon only |
| `IconText(painter: Painter, text: String, placement: CatSegmentedControlPlacement, iconContentDescription: String?)` | Icon and text side by side |

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

The default color mapping comes from the design tokens, and `ProvideAccentColor(...)` overrides the primary palette for the current subtree.

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

## Recommended usage

Use the item-based overload when you need the full design-system behavior.

```kotlin
var selectedValue by remember { mutableStateOf("Enabled") }

CatSegmentedControl(
    modifier = Modifier.fillMaxWidth(),
    firstItem = CatSegmentedControlItem("Enabled", CatSegmentedControlContent.TextOnly("Enabled")),
    secondItem = CatSegmentedControlItem("Paused", CatSegmentedControlContent.TextOnly("Paused")),
    selectedValue = selectedValue,
    onSelectionChange = { selectedValue = it },
)
```

For icon-based or mixed-content segments, use the generic `items` overload:

```kotlin
CatSegmentedControl(
    items = listOf(
        CatSegmentedControlItem("Day", CatSegmentedControlContent.IconText(icon, "Day")),
        CatSegmentedControlItem("Week", CatSegmentedControlContent.TextOnly("Week")),
    ),
    selectedValue = selectedValue,
    onSelectionChange = { selectedValue = it },
)
```

---

## Disabled item

Disable an individual segment without disabling the whole control:

```kotlin
CatSegmentedControl(
    items = listOf(
        CatSegmentedControlItem("Upcoming", CatSegmentedControlContent.TextOnly("Upcoming")),
        CatSegmentedControlItem(
            value = "Archived",
            content = CatSegmentedControlContent.TextOnly("Archived"),
            enabled = false,
        ),
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

The generic `items` overload supports more than two segments and should be used whenever the control needs richer content or values.

---

## Style override

`style: CatSegmentedControlColors?` is an escape hatch, not the normal design-system path.

Use it only when you have a one-off UI requirement that cannot be expressed through the standard semantic color roles and design tokens.

---

## Accessibility

- The control uses single-select semantics via `selectableGroup()` and per-segment `Role.RadioButton`
- Text and icon semantics are merged into the segment for discoverability without test tags
- For icon-only segments, provide a meaningful `contentDescription`

