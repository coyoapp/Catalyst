[← Back to README](../../README.md)

# CatButton — iOS

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

`CatButton` is configured entirely through the SwiftUI environment — there is no style parameter on the initializer. Use `.catButtonConfig(variant:color:)` on a parent view to set the appearance for all buttons in that subtree.

---

## Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `content` | `CatButtonContent` | required | Button content: `.text`, `.icon`, or `.iconText` |
| `buttonSize` | `CatButtonSize` | `.medium` | Size preset: `.extraSmall`, `.small`, `.medium`, `.custom(CGFloat)` |
| `styleFont` | `Font?` | `nil` | Overrides the default variant-driven font |
| `stackSpacing` | `CGFloat?` | `nil` | Overrides spacing between icon and label |
| `padding` | `EdgeInsets?` | `nil` | Overrides internal padding |
| `action` | `() -> Void` | required | Closure invoked on tap |

---

## Variants

| Variant | Description |
|---------|-------------|
| `.filled` | Solid background — primary call to action |
| `.outlined` | Transparent background with colored border |
| `.text` | Transparent, no border — low-emphasis action |
| `.link` | Transparent, no border — underline on hover/press |

---

## Color roles

| Color | Usage |
|-------|-------|
| `.primary` | Default. Overridable via `.catalystAccentColor(_:)` for whitelabeling |
| `.secondary` | Secondary actions |
| `.danger` | Destructive actions |
| `.success` | Confirmation actions |
| `.warning` | Warning actions |
| `.info` | Informational actions |
| `.primaryInverted` / `.secondaryInverted` | Use on dark backgrounds |

---

## Basic usage

```swift
// Default: filled, primary color
CatButton(.text("Confirm")) {
    // action
}

// Icon only
CatButton(.icon(Image(systemName: "plus"))) {
    // action
}

// Icon + label
CatButton(.iconText(icon: Image(systemName: "trash"), text: "Delete", placement: .leading)) {
    // action
}
```

---

## Setting variant and color

Apply `.catButtonConfig(variant:color:)` to the button or any parent view:

```swift
// Single button
CatButton(.text("Delete")) { }
    .catButtonConfig(variant: .filled, color: .danger)

// Entire group — all buttons inherit the config
VStack {
    CatButton(.text("Confirm")) { }
    CatButton(.text("Cancel")) { }
}
.catButtonConfig(variant: .outlined, color: .primary)
```

Nested modifiers override the parent for that subtree only:

```swift
VStack {
    CatButton(.text("Primary action")) { }    // .filled, .primary

    VStack {
        CatButton(.text("Danger action")) { } // .filled, .danger — inner wins
    }
    .catButtonConfig(variant: .filled, color: .danger)
}
.catButtonConfig(variant: .filled, color: .primary)
```

---

## Size

```swift
CatButton(.text("Small"), buttonSize: .small) { }
CatButton(.text("Extra small"), buttonSize: .extraSmall) { }
CatButton(.text("Custom height"), buttonSize: .custom(56)) { }
```

---

## Whitelabeling (brand / accent color)

`.catalystAccentColor(_:)` replaces the `.primary` palette for the entire subtree. All four variants respond automatically. Buttons using other color roles are unaffected.

```swift
// Set once at the root — every primary button picks up the brand color
ContentView()
    .catalystAccentColor(brandColor)

// Mixed: brand color for primary, standard tokens for danger
VStack {
    CatButton(.text("Book now")) { }
        // .filled + .primary → brandColor background

    CatButton(.text("Book now")) { }
        .catButtonConfig(variant: .outlined, color: .primary)
        // .outlined + .primary → brandColor border and text

    CatButton(.text("Delete")) { }
        .catButtonConfig(variant: .filled, color: .danger)
        // unaffected by accent color
}
.catalystAccentColor(brandColor)
```

---

## Theme

```swift
VStack {
    CatButton(.text("Confirm")) { }
}
.catalystTheme(.primaryHaiilo)
```
