[← Back to README](../../README.md)

# CatButton — Android

`CatButton` is the single button composable for the Catalyst Android design system. It is configured through parameters and, optionally, through the composition tree via `ProvideCatButtonConfig`.


---

## Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `content` | `CatButtonContent` | required | What the button displays — text, icon, or icon + text. See [Content](#content) |
| `onClick` | `() -> Unit` | required | Called when the button is tapped |
| `modifier` | `Modifier` | `Modifier` | Applied to the outer container |
| `variant` | `CatButtonVariant?` | `null` | Visual shape. `null` delegates to the ambient `LocalCatButtonConfig`. Use `ProvideCatButtonConfig` to set it for a subtree; without a provider it falls back to `Filled` |
| `color` | `CatButtonColor?` | `null` | Semantic color role. `null` delegates to the ambient `LocalCatButtonConfig`. Use `ProvideCatButtonConfig` to set it for a subtree; without a provider it falls back to `Primary` |
| `size` | `CatButtonSize` | `Small` | Controls button height and horizontal padding. See [Size](#size) |
| `enabled` | `Boolean` | `true` | When `false`, the button renders in the disabled state and ignores taps |
| `style` | `CatButtonState?` | `null` | Full state-style override. When non-null, `variant` and `color` are ignored for styling |

---

## Variants

Set via the `variant` parameter or through `ProvideCatButtonConfig`.

| Variant | Description |
|---------|-------------|
| `Filled` | Solid background — primary call to action |
| `Outlined` | Transparent background with a colored border |
| `Text` | Transparent, no border — low-emphasis action |
| `Link` | Transparent, no border — label is always underlined |

---

## Color roles

Set via the `color` parameter or through `ProvideCatButtonConfig`.

| Color | Usage |
|-------|-------|
| `Primary` | Default action |
| `Secondary` | Secondary actions |
| `Danger` | Destructive actions |
| `Success` | Confirmation actions |
| `Warning` | Warning actions |
| `Info` | Informational actions |
| `PrimaryInverted` / `SecondaryInverted` | Use on dark backgrounds |

---

## Content

`CatButtonContent` is a sealed class with three cases:

| Case | Description |
|------|-------------|
| `TextOnly(text: String, textConfig: CatButtonTextConfig?)` | Text label only |
| `IconOnly(painter: Painter, contentDescription: String?)` | Icon only |
| `IconText(painter: Painter, text: String, placement: CatButtonPlacement, iconContentDescription: String?, textConfig: CatButtonTextConfig?)` | Icon and text label side by side |

`CatButtonPlacement` controls where the icon sits relative to the label:

| Value | Description |
|-------|-------------|
| `Leading` | Icon to the left of the text (default) |
| `Trailing` | Icon to the right of the text |

### Text Configuration

Both `TextOnly` and `IconText` accept an optional `CatButtonTextConfig` parameter to control text layout and overflow behavior:

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `maxLines` | `Int` | `1` | Maximum number of text lines. Use `Int.MAX_VALUE` for unlimited lines |
| `overflow` | `TextOverflow` | `TextOverflow.Ellipsis` | Determines how text is truncated: `Clip`, `Ellipsis`, `Visible` |
| `textAlign` | `TextAlign` | `TextAlign.Center` | Text alignment within the button: `Left`, `Center`, `Right`, `Start`, `End` |

---

## Size

`CatButtonSize` is a sealed class. Heights and paddings come directly from Figma design tokens.

| Size | Height | Horizontal padding |
|------|--------|--------------------|
| `XSmall` | 32 dp | 8 dp |
| `Small` *(default)* | 40 dp | 16 dp |
| `Medium` | 48 dp | 16 dp |
| `Custom(height, horizontalPadding)` | caller-supplied | caller-supplied |

---

## Basic usage

```kotlin
// Text only — Filled Primary (defaults)
CatButton(
    content = CatButtonContent.TextOnly("Confirm"),
    onClick = { /* action */ },
)

// Text only with multi-line support
CatButton(
    content = CatButtonContent.TextOnly(
        text = "This is a longer button label",
        textConfig = CatButtonTextConfig(maxLines = 2),
    ),
    onClick = { /* action */ },
)

// Icon only
CatButton(
    content = CatButtonContent.IconOnly(
        painter = painterResource(R.drawable.icon_checkmark),
        contentDescription = "Confirm",
    ),
    onClick = { /* action */ },
    variant = CatButtonVariant.Filled,
    color = CatButtonColor.Primary,
)

// Icon + label
CatButton(
    content = CatButtonContent.IconText(
        painter = painterResource(R.drawable.icon_trash),
        text = "Delete",
        placement = CatButtonPlacement.Leading,
    ),
    onClick = { /* action */ },
    variant = CatButtonVariant.Filled,
    color = CatButtonColor.Danger,
)

// Icon + label with custom text handling
CatButton(
    content = CatButtonContent.IconText(
        painter = painterResource(R.drawable.icon_info),
        text = "Long information message",
        placement = CatButtonPlacement.Leading,
        textConfig = CatButtonTextConfig(
            maxLines = 2,
            overflow = TextOverflow.Ellipsis,
            textAlign = TextAlign.Start,
        ),
    ),
    onClick = { /* action */ },
)
```

---

## Variant and color

Pass `variant` and `color` directly on each button:

```kotlin
CatButton(
    content = CatButtonContent.TextOnly("Save"),
    onClick = { },
    variant = CatButtonVariant.Outlined,
    color = CatButtonColor.Primary,
)
```

---

## Size

```kotlin
CatButton(
    content = CatButtonContent.TextOnly("XSmall"),
    onClick = { },
    size = CatButtonSize.XSmall,
)

CatButton(
    content = CatButtonContent.TextOnly("Custom"),
    onClick = { },
    size = CatButtonSize.Custom(height = 56.dp, horizontalPadding = 24.dp),
)

// Larger size with multi-line text support
CatButton(
    content = CatButtonContent.TextOnly(
        text = "Long label with multiple lines",
        textConfig = CatButtonTextConfig(maxLines = 2),
    ),
    onClick = { },
    size = CatButtonSize.Medium,
)
```

---

## Full width

Apply `Modifier.fillMaxWidth()` to stretch the button to its parent width:

```kotlin
CatButton(
    content = CatButtonContent.TextOnly("Submit"),
    onClick = { },
    modifier = Modifier.fillMaxWidth(),
    variant = CatButtonVariant.Filled,
    color = CatButtonColor.Primary,
)
```

---

## Handling text overflow

By default, button text is limited to a single line with ellipsis truncation. Use `CatButtonTextConfig` to customize this behavior:

### Single line with truncation (default)
```kotlin
CatButton(
    content = CatButtonContent.TextOnly("Short"),
    onClick = { },
)
// Result: "Short" (ellipsis not visible since it fits)
```

### Multi-line text
```kotlin
CatButton(
    content = CatButtonContent.TextOnly(
        text = "This is a very long button label that needs multiple lines",
        textConfig = CatButtonTextConfig(maxLines = 2),
    ),
    onClick = { },
)
// Result: "This is a very long button label that needs" (wrapped to 2 lines)
```

### Custom overflow behavior
```kotlin
CatButton(
    content = CatButtonContent.TextOnly(
        text = "Long text",
        textConfig = CatButtonTextConfig(
            maxLines = 1,
            overflow = TextOverflow.Clip,  // Clip instead of ellipsis
        ),
    ),
    onClick = { },
)
```

### Text alignment
```kotlin
CatButton(
    content = CatButtonContent.TextOnly(
        text = "Left aligned",
        textConfig = CatButtonTextConfig(textAlign = TextAlign.Start),
    ),
    onClick = { },
)
```

---

## Disabled state

```kotlin
CatButton(
    content = CatButtonContent.TextOnly("Unavailable"),
    onClick = { },
    enabled = false,
)
```

---

## ProvideCatButtonConfig

`ProvideCatButtonConfig` injects a default `variant` and `color` into the composition tree. Any `CatButton` inside that tree that does not pass its own `variant`/`color` inherits these values.

```kotlin
ProvideCatButtonConfig(
    variant = CatButtonVariant.Outlined,
    color = CatButtonColor.Warning,
) {
    Row {
        // Inherits Outlined + Warning
        CatButton(content = CatButtonContent.TextOnly("Button A"), onClick = { })
        CatButton(content = CatButtonContent.TextOnly("Button B"), onClick = { })

        // Overrides color at the call site only
        CatButton(
            content = CatButtonContent.TextOnly("Override"),
            onClick = { },
            color = CatButtonColor.Info,
        )
    }
}
```

Nested providers override the parent for their subtree:

```kotlin
ProvideCatButtonConfig(variant = CatButtonVariant.Filled, color = CatButtonColor.Primary) {
    Column {
        CatButton(content = CatButtonContent.TextOnly("Primary action"), onClick = { })

        ProvideCatButtonConfig(variant = CatButtonVariant.Filled, color = CatButtonColor.Danger) {
            CatButton(content = CatButtonContent.TextOnly("Danger action"), onClick = { })
        }
    }
}
```

---

## Inverted colors (dark backgrounds)

Use `PrimaryInverted` or `SecondaryInverted` when placing buttons on a dark surface:

```kotlin
Box(modifier = Modifier.background(CatColors.Ui.Background.surfaceInverted)) {
    CatButton(
        content = CatButtonContent.TextOnly("Action"),
        onClick = { },
        variant = CatButtonVariant.Filled,
        color = CatButtonColor.PrimaryInverted,
    )
}
```

---

## Style override

Pass a fully custom `CatButtonState` to bypass variant/color token resolution entirely. This is an escape hatch for one-off styling and should not be used for standard design system usage.

```kotlin
CatButton(
    content = CatButtonContent.TextOnly("Custom"),
    onClick = { },
    style = CatButtonState(
        normal   = CatButtonStateStyle(CatButtonStateColorStyle(background = myBg, foreground = myFg, border = Color.Transparent)),
        pressed  = CatButtonStateStyle(CatButtonStateColorStyle(background = myBgPressed, foreground = myFg, border = Color.Transparent)),
        focused  = CatButtonStateStyle(CatButtonStateColorStyle(background = myBg, foreground = myFg, border = Color.Transparent)),
        disabled = CatButtonStateStyle(CatButtonStateColorStyle(background = Color.Gray, foreground = Color.LightGray, border = Color.Transparent)),
    ),
)
```

---

## Whitelabel / Accent color

Catalyst supports a single brand accent color that automatically replaces the default `Primary` palette on all `CatButton(color = CatButtonColor.Primary)` buttons. All other color roles (`Danger`, `Success`, etc.) are unaffected.

### App-wide setup

Call `CatThemeConfig.configure()` **once**, before `setContent {}`, in `Application.onCreate()` or `Activity.onCreate()`. `CatTheme` reads this value at composition time and injects it automatically — no wrapper needed around individual buttons.

```kotlin
// Application.onCreate() or Activity.onCreate(), before setContent {}

// From a hex string (strings.xml or colors.xml):
CatThemeConfig.configure("#1A73E8")

// Or from a Compose Color value:
CatThemeConfig.configure(Color(0xFF1A73E8))
```

```xml
<!-- res/values/strings.xml -->
<string name="brand_accent">#1A73E8</string>

<!-- res/values/colors.xml -->
<color name="brand_accent">#FF1A73E8</color>
```

```kotlin
// Using a resource value:
CatThemeConfig.configure(getString(R.string.brand_accent))
```

### Per-subtree override

Use `ProvideAccentColor` to override the accent for a specific part of the UI without affecting the rest of the app:

```kotlin
ProvideAccentColor(Color(0xFFE8340A)) {
    CatButton(
        content = CatButtonContent.TextOnly("Delete"),
        onClick = { },
        variant = CatButtonVariant.Filled,
        color = CatButtonColor.Primary, // uses the red accent in this subtree
    )
}
```

### How it works

| Layer | API | Scope |
|-------|-----|-------|
| App-wide | `CatThemeConfig.configure(color)` | All `Primary` buttons inside `CatTheme {}` |
| Subtree | `ProvideAccentColor(color) { }` | All `Primary` buttons inside the provider |
| Button | `CatButton(style = …)` | Single button — full override, accent ignored |

The hover and pressed shades are derived from the base accent color by darkening its HSL lightness by **5 %** (hover) and **11 %** (pressed), matching the iOS implementation.
```
