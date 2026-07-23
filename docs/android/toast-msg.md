[← Back to README](../../README.md)

# CatToastMsg — Android

`CatToastMsg` is the floating toast notification composable for the Catalyst Android design system. It displays a leading icon, a message title, and an optional action slot inside a dark rounded surface that anchors at the bottom of the screen. The surface always uses an inverted (dark) background with inverted (light) text.

Layout variants:
- **Compact** — single row, fixed 56 dp height. Icon + title + action + dismiss on one line.
- **Expanded** — stacked layout. Title wraps freely; action sits below the title; dismiss anchors top-end.

Fixed width: 343 dp per design spec.

---

## Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `title` | `String` | required | The toast's message text |
| `modifier` | `Modifier` | `Modifier` | Applied to the outer container |
| `variant` | `CatToastMsgVariant?` | `null` | Layout mode override. `null` delegates to ambient `LocalCatToastMsgConfig`; without a provider it falls back to `Compact` |
| `leadingIcon` | `Painter?` | `null` | Optional leading status icon. `null` hides the icon slot |
| `showDismissButton` | `Boolean` | `true` | When `true`, an internal × dismiss button is shown |
| `onDismiss` | `(() -> Unit)?` | `null` | Called when the dismiss button is tapped. `null` means the button renders but is a no-op |
| `colors` | `CatToastMsgColors?` | `null` | Full color override. When non-null, token resolution is skipped. See [Color override](#color-override) |
| `action` | `(@Composable () -> Unit)?` | `null` | Optional action slot, typically a `CatButton` with `color = CatButtonColor.PrimaryInverted` |

---

## Variants

| Variant | Layout | Best for |
|---------|--------|----------|
| `Compact` | Single row, 56 dp tall | Short messages — title fits on one line |
| `Expanded` | Stacked — title wraps, action below | Longer messages or when the action needs its own line |

---

## Basic usage

```kotlin
// Compact — title only, no dismiss
CatToastMsg(
    title = "File successfully saved",
    showDismissButton = false,
)
```

---

## With leading icon

```kotlin
CatToastMsg(
    title = "Changes saved",
    leadingIcon = painterResource(R.drawable.ic_check_circle_outlined_24),
    showDismissButton = false,
)
```

---

## With dismiss button

```kotlin
CatToastMsg(
    title = "No internet connection",
    leadingIcon = painterResource(R.drawable.ic_info_outlined_25),
    showDismissButton = true,
    onDismiss = { /* handle dismiss */ },
)
```

---

## With action slot

The action slot accepts any composable. Use `CatButtonColor.PrimaryInverted` to match the inverted surface.

```kotlin
// Text variant button
CatToastMsg(
    title = "File successfully saved",
    leadingIcon = painterResource(R.drawable.ic_check_circle_outlined_24),
    showDismissButton = true,
    onDismiss = { /* dismiss */ },
    action = {
        CatButton(
            content = CatButtonContent.TextOnly("Undo"),
            onClick = { /* undo */ },
            variant = CatButtonVariant.Text,
            color = CatButtonColor.PrimaryInverted,
            size = CatButtonSize.XSmall,
        )
    },
)

// Outlined variant button
CatToastMsg(
    title = "Profile updated",
    leadingIcon = painterResource(R.drawable.ic_info_outlined_25),
    showDismissButton = true,
    onDismiss = { /* dismiss */ },
    action = {
        CatButton(
            content = CatButtonContent.TextOnly("View"),
            onClick = { /* view */ },
            variant = CatButtonVariant.Outlined,
            color = CatButtonColor.PrimaryInverted,
            size = CatButtonSize.XSmall,
        )
    },
)
```

---

## Expanded variant

```kotlin
CatToastMsg(
    title = "Your file has been successfully saved to the cloud and is now available on all your devices.",
    variant = CatToastMsgVariant.Expanded,
    leadingIcon = painterResource(R.drawable.ic_info_outlined_25),
    showDismissButton = true,
    onDismiss = { /* dismiss */ },
    action = {
        CatButton(
            content = CatButtonContent.TextOnly("View file"),
            onClick = { /* view */ },
            variant = CatButtonVariant.Text,
            color = CatButtonColor.PrimaryInverted,
            size = CatButtonSize.XSmall,
        )
    },
)
```

---

## ProvideCatToastMsgConfig

`ProvideCatToastMsgConfig` injects a default `variant` into the composition tree. Any `CatToastMsg` inside that tree that does not pass its own `variant` inherits this value.

```kotlin
ProvideCatToastMsgConfig(variant = CatToastMsgVariant.Expanded) {
    Column {
        // Both inherit Expanded from the ambient config
        CatToastMsg(
            title = "First notification",
            onDismiss = { },
        )
        CatToastMsg(
            title = "Second notification",
            onDismiss = { },
        )

        // Call-site override still wins
        CatToastMsg(
            title = "Compact override",
            variant = CatToastMsgVariant.Compact,
            onDismiss = { },
        )
    }
}
```

---

## Color override

Pass a fully custom `CatToastMsgColors` to bypass token resolution. This is an escape hatch and should not be used for standard design system usage.

```kotlin
CatToastMsg(
    title = "Custom styled toast",
    colors = CatToastMsgColors(
        background = myBackground,
        foreground = myForeground,
        actionColor = myActionColor,
    ),
)
```

---

## Whitelabel / Accent color

The action color defaults to `CatColors.Theme.PrimaryInverted.text`. Pass an accent palette to `CatToastMsgDefaults.colors()` to override it for a specific toast:

```kotlin
val accentPalette = LocalCatAccentPalette.current

CatToastMsg(
    title = "Branded notification",
    colors = CatToastMsgDefaults.colors(accentPalette = accentPalette),
    action = {
        CatButton(
            content = CatButtonContent.TextOnly("Action"),
            onClick = { },
            variant = CatButtonVariant.Text,
            color = CatButtonColor.PrimaryInverted,
            size = CatButtonSize.XSmall,
        )
    },
)
```

The app-wide accent is configured once before `setContent {}`:

```kotlin
// Activity.onCreate(), before setContent {}
CatThemeConfig.configure("#1A73E8")
```
