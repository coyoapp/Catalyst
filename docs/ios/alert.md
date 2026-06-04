[← Back to README](../../README.md)

# CatAlert — iOS

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

`CatAlert` is a card-style inline alert: a leading icon, a heading, and an optional trailing action button inside a rounded card with a variant-colored border. The semantic color is set through the SwiftUI environment with `.catAlertConfig(variant:)`; the icon and action are initializer parameters.

The action button is laid out **responsively** — it sits inline to the right of the heading when everything fits on one line, and drops below the heading when the heading is long enough to wrap.

---

## Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `heading` | `String` | required | The alert heading text |
| `icon` | `Image` | info-circle (Catalyst bundle) | Leading icon, tinted to the variant color. Overridable for every variant |
| `action` | `() -> some View` | none (optional) | Optional trailing action view, typically a `CatButton`. Omit for an icon + heading only alert |

---

## Variants (color roles)

Set with `.catAlertConfig(variant:)`. Each variant drives the card border, the heading color, and the icon tint.

| Variant | Usage |
|---------|-------|
| `.info` | Informational messages (blue) |
| `.success` | Success / confirmation (green) |
| `.warning` | Warnings (amber) |
| `.danger` | Errors / destructive context (red) |
| `.neutral` | Low-emphasis, neutral messages (black text, neutral border) |
| `.brand` | Brand-colored. Overridable via `.catalystAccentColor(_:)` for whitelabeling (teal by default) |

---

## Basic usage

```swift
// Icon + heading + action button (default variant: .info)
CatAlert("Your changes were saved") {
    CatButton(.text("Undo"), buttonSize: .small) { }
        .catButtonConfig(variant: .outlined, color: .primary)
}

// Icon + heading only (no action button)
CatAlert("Read-only mode is on")
    .catAlertConfig(variant: .neutral)

// Custom leading icon
CatAlert(
    "Upload complete",
    icon: Image("icon-checkmark", bundle: .catalyst)
) {
    CatButton(.text("View"), buttonSize: .small) { }
        .catButtonConfig(variant: .outlined, color: .primary)
}
.catAlertConfig(variant: .success)
```

---

## Setting the variant

Apply `.catAlertConfig(variant:)` to the alert or any parent view:

```swift
// Single alert
CatAlert("Something went wrong") {
    CatButton(.text("Retry"), buttonSize: .small) { }
        .catButtonConfig(variant: .outlined, color: .primary)
}
.catAlertConfig(variant: .danger)

// Entire group — all alerts inherit the variant
VStack {
    CatAlert("First notice")
    CatAlert("Second notice")
}
.catAlertConfig(variant: .info)
```

A nested modifier overrides the parent for that subtree only.

---

## Whitelabeling (brand / accent color)

`.catalystAccentColor(_:)` replaces the `.brand` variant's color for the entire subtree. Other variants are unaffected.

```swift
// Set once at the root — every .brand alert picks up the client's color
ContentView()
    .catalystAccentColor(brandColor)

// Mixed: brand color for .brand, standard tokens for .danger
VStack {
    CatAlert("Welcome back")            // .brand → brandColor border + heading
        .catAlertConfig(variant: .brand)

    CatAlert("Payment failed") {        // unaffected by accent color
        CatButton(.text("Retry"), buttonSize: .small) { }
            .catButtonConfig(variant: .outlined, color: .primary)
    }
    .catAlertConfig(variant: .danger)
}
.catalystAccentColor(brandColor)
```

---

## Accessibility

`CatAlert` does not set an accessibility label. The heading and the action button remain individually accessible, so the consuming view can assign accessibility values appropriate to its context.

---

## Theme

```swift
VStack {
    CatAlert("Themed alert")
}
.catalystTheme(.primaryHaiilo)
```
