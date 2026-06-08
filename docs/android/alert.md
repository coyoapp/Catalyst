[← Back to README](../../README.md)

# CatAlert — Android

`CatAlert` is the alert card composable for the Catalyst Android design system. It displays a leading icon, a heading text, and an optional trailing action inside a semantically colored bordered card. It can be configured per call site or through the composition tree via `ProvideCatAlertConfig`.

Visual defaults:
- Background defaults to transparent, so it inherits the parent surface.
- Border width is `2 dp`.
- Border color uses `30 %` opacity of the semantic role color.

---

## Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `heading` | `String` | required | The heading text displayed in the alert |
| `leadingIcon` | `Painter` | built-in info icon | Icon shown at the start of the alert. Defaults to `R.drawable.info_circle_outlined` |
| `modifier` | `Modifier` | `Modifier` | Applied to the outer card container |
| `color` | `CatAlertColor?` | `null` | Semantic color role override. `null` delegates to ambient `LocalCatAlertConfig`; without a provider it falls back to `Info` |
| `buttonPlacement` | `CatAlertButtonPlacement` | `Automatic` | Controls where the action is placed. See [Button placement](#button-placement) |
| `iconContentDescription` | `String?` | `null` | Accessibility description for the leading icon. Pass `null` if the icon is purely decorative |
| `style` | `CatAlertColors?` | `null` | Full color override. When non-null, `color` is ignored for styling |
| `action` | `(@Composable () -> Unit)?` | `null` | Optional action slot. Typically a `CatButton`, but any composable can be supplied |

---

## Color roles

Set via the `color` parameter or through `ProvideCatAlertConfig`.

| Color | Usage |
|-------|-------|
| `Primary` | Default action — teal |
| `Info` | Informational messages — blue |
| `Success` | Confirmation messages — green |
| `Warning` | Warning messages — amber |
| `Danger` | Destructive or error messages — red |
| `Default` | Neutral — no semantic color, uses UI border and font tokens |

`CatAlertColor.Primary` follows the same Android accent-color behavior as `CatButtonColor.Primary`.
If the host app configures `CatThemeConfig.configure(...)` (or uses `ProvideAccentColor`), Primary alerts use the active accent color.

---

## Button placement

`CatAlertButtonPlacement` controls the layout of the action relative to the heading text.

| Value | Layout | Best for |
|-------|--------|----------|
| `Automatic` | Keeps the action trailing when the heading fits on one line; otherwise moves it below the heading | Default adaptive behavior |
| `Trailing` | Button on the trailing edge in the same row as the heading | Short, single-line headings |
| `Below` | Button below the heading text, start-aligned | Longer headings that wrap to multiple lines |

---

## Basic usage

```kotlin
// Info alert — default color, default icon, no action
CatAlert(
    heading = "Your session will expire soon",
)
```

---

## Action slot

Pass any composable into `action`. In most cases this will be a `CatButton`.

```kotlin
CatAlert(
    heading = "Your session will expire soon",
    color = CatAlertColor.Info,
    action = {
        CatButton(
            content = CatButtonContent.TextOnly("Renew"),
            onClick = { /* action */ },
            variant = CatButtonVariant.Outlined,
            color = CatButtonColor.Secondary,
        )
    },
)
```

---

## Color examples

```kotlin
CatAlert(
    heading = "Changes saved successfully",
    leadingIcon = painterResource(R.drawable.icon_checkmark),
    color = CatAlertColor.Success,
    action = {
        CatButton(
            content = CatButtonContent.TextOnly("Dismiss"),
            onClick = { },
            variant = CatButtonVariant.Outlined,
            color = CatButtonColor.Secondary,
        )
    },
)

CatAlert(
    heading = "This action cannot be undone",
    color = CatAlertColor.Danger,
    action = {
        CatButton(
            content = CatButtonContent.TextOnly("Continue"),
            onClick = { },
            variant = CatButtonVariant.Outlined,
            color = CatButtonColor.Secondary,
        )
    },
)

CatAlert(
    heading = "Review required before proceeding",
    color = CatAlertColor.Warning,
    action = {
        CatButton(
            content = CatButtonContent.TextOnly("Review"),
            onClick = { },
            variant = CatButtonVariant.Outlined,
            color = CatButtonColor.Secondary,
        )
    },
)
```

---

## Automatic placement

`Automatic` is the default. It keeps the action inline for short headings and moves it below when the heading does not fit on one line.

```kotlin
// Short heading: action stays trailing
CatAlert(
    heading = "Saved successfully",
    action = {
        CatButton(
            content = CatButtonContent.TextOnly("Undo"),
            onClick = { },
            variant = CatButtonVariant.Outlined,
            color = CatButtonColor.Secondary,
        )
    },
)

// Long heading: action automatically moves below
CatAlert(
    heading = "This is a longer heading that needs more than one line to display fully",
    action = {
        CatButton(
            content = CatButtonContent.TextOnly("Action"),
            onClick = { },
            variant = CatButtonVariant.Outlined,
            color = CatButtonColor.Secondary,
        )
    },
)
```

---

## Explicit trailing placement

Use `CatAlertButtonPlacement.Trailing` to keep the action inline even when you want to opt out of the automatic layout decision.

```kotlin
CatAlert(
    heading = "Short heading",
    buttonPlacement = CatAlertButtonPlacement.Trailing,
    action = {
        CatButton(
            content = CatButtonContent.TextOnly("Undo"),
            onClick = { },
            variant = CatButtonVariant.Outlined,
            color = CatButtonColor.Secondary,
        )
    },
)
```

---

## Explicit below placement

Use `CatAlertButtonPlacement.Below` when the heading is long enough to wrap across multiple lines:

```kotlin
CatAlert(
    heading = "This is a longer heading that needs more than one line to display fully",
    color = CatAlertColor.Info,
    buttonPlacement = CatAlertButtonPlacement.Below,
    action = {
        CatButton(
            content = CatButtonContent.TextOnly("Action"),
            onClick = { },
            variant = CatButtonVariant.Outlined,
            color = CatButtonColor.Secondary,
        )
    },
)
```

---

## Optional action

The action is optional. When omitted, `CatAlert` renders only the icon and heading.

```kotlin
CatAlert(
    heading = "Informational message without an action",
    color = CatAlertColor.Info,
)
```

---

## Disabled state

Disabled behavior is controlled by the composable you pass into `action`.

```kotlin
CatAlert(
    heading = "Action is currently unavailable",
    color = CatAlertColor.Info,
    action = {
        CatButton(
            content = CatButtonContent.TextOnly("Action"),
            onClick = { },
            variant = CatButtonVariant.Outlined,
            color = CatButtonColor.Secondary,
            enabled = false,
        )
    },
)
```

---

## ProvideCatAlertConfig

`ProvideCatAlertConfig` injects a default `color` into the composition tree. Any `CatAlert` inside that tree that does not pass its own `color` inherits this value.

```kotlin
ProvideCatAlertConfig(color = CatAlertColor.Warning) {
    Column {
        // Inherits Warning
        CatAlert(
            heading = "Profile is incomplete",
            action = {
                CatButton(
                    content = CatButtonContent.TextOnly("Review"),
                    onClick = { },
                    variant = CatButtonVariant.Outlined,
                    color = CatButtonColor.Secondary,
                )
            },
        )

        // Overrides at call site only
        CatAlert(
            heading = "Payment failed",
            color = CatAlertColor.Danger,
            action = {
                CatButton(
                    content = CatButtonContent.TextOnly("Retry"),
                    onClick = { },
                    variant = CatButtonVariant.Outlined,
                    color = CatButtonColor.Secondary,
                )
            },
        )
    }
}
```

---

## Style override

Pass a fully custom `CatAlertColors` to bypass semantic token resolution. This is an escape hatch for one-off styling and should not be used for standard design system usage.

```kotlin
CatAlert(
    heading = "Custom",
    style = CatAlertColors(
        border = myBorder,
        icon = myIcon,
        text = myText,
        background = myBackground,
    ),
    action = {
        CatButton(
            content = CatButtonContent.TextOnly("Action"),
            onClick = { },
            variant = CatButtonVariant.Outlined,
            color = CatButtonColor.Secondary,
        )
    },
)
```

---

## Whitelabel / Accent color

`CatAlertColor.Primary` follows the same Android accent-color behavior as `CatButtonColor.Primary`.

### App-wide setup

Call `CatThemeConfig.configure()` **once**, before `setContent {}`, in `Application.onCreate()` or `Activity.onCreate()`.

```kotlin
// From a hex string:
CatThemeConfig.configure("#1A73E8")

// Or from a Compose Color value:
CatThemeConfig.configure(Color(0xFF1A73E8))
```

### Per-subtree override

Use `ProvideAccentColor` to override the accent for a specific part of the UI:

```kotlin
ProvideAccentColor(Color(0xFFE8340A)) {
    CatAlert(
        heading = "Delete requested",
        color = CatAlertColor.Primary,
        action = {
            CatButton(
                content = CatButtonContent.TextOnly("Review"),
                onClick = { },
                variant = CatButtonVariant.Outlined,
                color = CatButtonColor.Secondary,
            )
        },
    )
}
```

---

## Accessibility — icon content description

Pass `iconContentDescription` when the icon conveys meaning that is not already expressed by the heading text:

```kotlin
CatAlert(
    heading = "Your password is about to expire",
    color = CatAlertColor.Warning,
    iconContentDescription = "Warning",
    action = {
        CatButton(
            content = CatButtonContent.TextOnly("Update password"),
            onClick = { },
            variant = CatButtonVariant.Outlined,
            color = CatButtonColor.Secondary,
        )
    },
)
```

Pass `null` (the default) when the icon is purely decorative and the heading already communicates the full message.

