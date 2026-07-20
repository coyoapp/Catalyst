[← Back to README](../../README.md)

# CatSegmentedControl — iOS

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

`CatSegmentedControl` is a horizontal control of equal-width, mutually-exclusive segments on a muted track. The selected segment renders as a white pill with a semibold, primary-colored label that slides between segments on selection change. Selection state is owned by the consumer via a plain index binding.

---

## Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `segments` | `[String]` | required | Segment titles, rendered left to right |
| `selection` | `Binding<Int>` | required | Index of the selected segment. Out-of-range values render with no selection pill until the user taps a segment |

---

## Basic usage

```swift
@State private var selected = 0

CatSegmentedControl(["Option 1", "Option 2"], selection: $selected)

// Any number of segments — widths stay equal:
CatSegmentedControl(["Summarize", "Explain", "Translate"], selection: $selected)
```

---

## Whitelabeling (brand / accent color)

`.catalystAccentColor(_:)` recolors the **selected label** for the subtree; the selection pill itself stays white (accent palettes keep `fill = .white`). Track and unselected colors are unaffected.

```swift
CatSegmentedControl(["Option 1", "Option 2"], selection: $selected)
    .catalystAccentColor(brandColor)
```

---

## Color roles

| Role | Token | Value |
|------|-------|-------|
| Track background | `color/ui/background/muted` | `#F2F4F7` |
| Selection pill | `color/theme/primary/fill` (accent-aware) | `#FFFFFF` |
| Selected label | `color/theme/primary/text` (accent-aware) | `#008194` |
| Unselected label | `color/ui/font/muted` | `#515C6C` |

| Structure | Token | Value |
|-----------|-------|-------|
| Selected label font | `App/Button1` | Lato Semibold 16 |
| Unselected label font | `App/Button2` | Lato Regular 16 |
| Segment height | `size/2xl` | 40 |
| Track radius | `border-radius/lg` | 12 |
| Pill radius | `border-radius/md` | 8 |
| Segment horizontal padding | `spacing/xl` | 16 |
| Track inset | `spacing/xs` | 4 |

---

## Accessibility

Each segment is a button; the selected one carries the `.isSelected` trait, so VoiceOver announces "selected". Segments are read left to right.

---

## Theme

```swift
CatSegmentedControl(["Option 1", "Option 2"], selection: $selected)
    .catalystTheme(.primaryHaiilo)
```
