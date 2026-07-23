[← Back to README](../../README.md)

# CatToastMsg — iOS

## Setup

Call `CatTheme.configure()` once at app startup to register fonts before using any Catalyst component:

```swift
// SwiftUI
@main
struct MyApp: App {
    init() {
        CatTheme.configure()
    }
}

// UIKit
func application(_ application: UIApplication, didFinishLaunchingWithOptions...) -> Bool {
    CatTheme.configure()
    return true
}
```

---

`CatToastMsg` is the floating toast notification component for the Catalyst iOS design system. It displays an optional leading icon, a message title, and an optional action slot inside a dark rounded surface that anchors at the bottom of the screen. The surface always uses an inverted (dark) background with inverted (light) text.

Layout variants:
- **compact** — single row, fixed 56 pt height. Icon + title + action + dismiss on one line.
- **expanded** — stacked layout. Title wraps freely; action sits below the title; dismiss anchors top-trailing.

Fixed width: 343 pt per design spec.

---

## Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `title` | `String` | required | The toast's message text |
| `icon` | `Image?` | `nil` | Optional leading status icon. `nil` hides the icon slot |
| `variant` | `CatToastMsgVariant` | `.compact` | Layout mode — `.compact` (single row) or `.expanded` (stacked) |
| `showDismissButton` | `Bool` | `true` | When `true`, an internal × dismiss button is shown |
| `onDismiss` | `(() -> Void)?` | `nil` | Closure invoked when the dismiss button is tapped. `nil` means the button renders but is a no-op |
| `action` | `() -> some View` | none (optional) | Optional action slot, typically a `CatButton` with `.primaryInverted` color |

---

## Variants

| Variant | Layout | Best for |
|---------|--------|----------|
| `.compact` | Single row, 56 pt tall | Short messages — title fits on one line |
| `.expanded` | Stacked — title wraps, action below | Longer messages or when the action needs its own line |

---

## Basic usage

```swift
// Compact — title only, no dismiss
CatToastMsg(
    "File successfully saved",
    showDismissButton: false
)
```

---

## With leading icon

```swift
CatToastMsg(
    "Changes saved",
    icon: Image("ic_check-circle-outlined-24", bundle: .catalyst),
    showDismissButton: false
)
```

---

## With dismiss button

```swift
CatToastMsg(
    "No internet connection",
    icon: Image("ic_info-outlined-25", bundle: .catalyst),
    onDismiss: { /* handle dismiss */ }
)
```

---

## With action slot

The action slot accepts any view. Use `.primaryInverted` color on `CatButton` to match the inverted surface.

```swift
// Text variant button
CatToastMsg(
    "File successfully saved",
    icon: Image("ic_check-circle-outlined-24", bundle: .catalyst),
    onDismiss: { /* dismiss */ }
) {
    CatButton(.text("Undo"), buttonSize: .extraSmall) {
        // undo
    }
    .catButtonConfig(variant: .text, color: .primaryInverted)
}

// Outlined variant button
CatToastMsg(
    "Profile updated",
    icon: Image("ic_info-outlined-25", bundle: .catalyst),
    onDismiss: { /* dismiss */ }
) {
    CatButton(.text("View"), buttonSize: .extraSmall) {
        // view
    }
    .catButtonConfig(variant: .outlined, color: .primaryInverted)
}
```

---

## Expanded variant

```swift
CatToastMsg(
    "Your file has been successfully saved to the cloud and is now available on all your devices.",
    icon: Image("ic_info-outlined-25", bundle: .catalyst),
    variant: .expanded,
    onDismiss: { /* dismiss */ }
) {
    CatButton(.text("View file"), buttonSize: .extraSmall) {
        // view
    }
    .catButtonConfig(variant: .text, color: .primaryInverted)
}
```

---

## Setting the variant via environment

Apply `.catToastMsgConfig(variant:)` to a parent view to set the variant for all toasts in that subtree without passing it on each call site:

```swift
VStack {
    CatToastMsg("First notification", onDismiss: { })
    CatToastMsg("Second notification", onDismiss: { })
}
.catToastMsgConfig(variant: .expanded)
```

A call-site `variant` parameter always overrides the environment:

```swift
VStack {
    // Inherits .expanded from the environment modifier
    CatToastMsg("Expanded toast", onDismiss: { })

    // Overrides to .compact at the call site
    CatToastMsg(
        "Compact override",
        variant: .compact,
        onDismiss: { }
    )
}
.catToastMsgConfig(variant: .expanded)
```

---

## Whitelabeling (accent color)

The action color defaults to `CatColors.Theme.PrimaryInverted.text`. Apply `.catalystAccentColor(_:)` to replace it for the entire subtree:

```swift
// Set once at the root — action buttons in every CatToastMsg pick up the brand color
ContentView()
    .catalystAccentColor(brandColor)

// Or scope it to a specific toast
CatToastMsg(
    "Branded notification",
    onDismiss: { }
) {
    CatButton(.text("Action"), buttonSize: .extraSmall) { }
        .catButtonConfig(variant: .text, color: .primaryInverted)
}
.catalystAccentColor(brandColor)
```

---

## Theme

```swift
VStack {
    CatToastMsg("Themed toast", onDismiss: { })
}
.catalystTheme(.primaryHaiilo)
```
