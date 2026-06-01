[← Back to README](../../README.md)

# CatAlert — Android

`CatAlert` is the alert card composable for the Catalyst Android design system. It displays a leading icon, a heading text, and an action button inside a semantically colored bordered card.

Visual defaults:
- Background defaults to transparent, so it inherits the parent surface.
- Border width is `2 dp`.
- Border color uses `30 %` opacity of the semantic role color.

---

## Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `heading` | `String` | required | The heading text displayed in the alert |
| `leadingIcon` | `Painter` | required | Icon shown at the start of the alert |
| `buttonText` | `String` | required | Label for the action button |
| `onButtonClick` | `() -> Unit` | required | Called when the action button is tapped |
| `modifier` | `Modifier` | `Modifier` | Applied to the outer card container |
| `color` | `CatAlertColor?` | `null` | Semantic color role override. `null` delegates to ambient `LocalCatAlertConfig`; without a provider it falls back to `Info` |
| `buttonPlacement` | `CatAlertButtonPlacement` | `Trailing` | Controls where the action button is placed. See [Button placement](#button-placement) |
| `iconContentDescription` | `String?` | `null` | Accessibility description for the leading icon. Pass `null` if the icon is purely decorative |
| `enabled` | `Boolean` | `true` | When `false`, the action button renders in the disabled state and ignores taps |
| `style` | `CatAlertColors?` | `null` | Full color override. When non-null, `color` is ignored for styling |

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

`CatAlertButtonPlacement` controls the layout of the action button relative to the heading text.

| Value | Layout | Best for |
|-------|--------|----------|
| `Trailing` | Button on the trailing edge in the same row as the heading | Short, single-line headings |
| `Below` | Button below the heading text, start-aligned | Longer headings that wrap to multiple lines |

---

## Basic usage

```kotlin
// Info alert — default color, trailing button
CatAlert(
    heading = "Your session will expire soon",
    leadingIcon = painterResource(R.drawable.info_circle_outlined),
    buttonText = "Renew",
    onButtonClick = { /* action */ },
)
```

---

## Color examples

```kotlin
CatAlert(
    heading = "Changes saved successfully",
    leadingIcon = painterResource(R.drawable.icon_checkmark),
    buttonText = "Dismiss",
    onButtonClick = { },
    color = CatAlertColor.Success,
)

CatAlert(
    heading = "This action cannot be undone",
    leadingIcon = painterResource(R.drawable.info_circle_outlined),
    buttonText = "Continue",
    onButtonClick = { },
    color = CatAlertColor.Danger,
)

CatAlert(
    heading = "Review required before proceeding",
    leadingIcon = painterResource(R.drawable.info_circle_outlined),
    buttonText = "Review",
    onButtonClick = { },
    color = CatAlertColor.Warning,
)
```

---

## Long heading — Below placement

Use `CatAlertButtonPlacement.Below` when the heading is long enough to wrap across multiple lines:

```kotlin
CatAlert(
    heading = "This is a longer heading that needs more than one line to display fully",
    leadingIcon = painterResource(R.drawable.info_circle_outlined),
    buttonText = "Action",
    onButtonClick = { },
    color = CatAlertColor.Info,
    buttonPlacement = CatAlertButtonPlacement.Below,
)
```

---

## Disabled state

```kotlin
CatAlert(
    heading = "Action is currently unavailable",
    leadingIcon = painterResource(R.drawable.info_circle_outlined),
    buttonText = "Action",
    onButtonClick = { },
    color = CatAlertColor.Info,
    enabled = false,
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
            leadingIcon = painterResource(R.drawable.info_circle_outlined),
            buttonText = "Review",
            onButtonClick = { },
        )

        // Overrides at call site only
        CatAlert(
            heading = "Payment failed",
            leadingIcon = painterResource(R.drawable.info_circle_outlined),
            buttonText = "Retry",
            onButtonClick = { },
            color = CatAlertColor.Danger,
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
    leadingIcon = painterResource(R.drawable.info_circle_outlined),
    buttonText = "Action",
    onButtonClick = { },
    style = CatAlertColors(
        border = myBorder,
        icon = myIcon,
        text = myText,
        background = myBackground,
    ),
)
```

---

## Accessibility — icon content description

Pass `iconContentDescription` when the icon conveys meaning that is not already expressed by the heading text:

```kotlin
CatAlert(
    heading = "Your password is about to expire",
    leadingIcon = painterResource(R.drawable.info_circle_outlined),
    buttonText = "Update password",
    onButtonClick = { },
    color = CatAlertColor.Warning,
    iconContentDescription = "Warning",
)
```

Pass `null` (the default) when the icon is purely decorative and the heading already communicates the full message.

