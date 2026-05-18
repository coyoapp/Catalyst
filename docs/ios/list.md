[← Back to README](../../README.md)

# CatList — iOS

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

`CatList` is a container that renders a group of navigation list items with automatic position assignment, divider insertion, and shared corner-radius clipping. Each row is built by `CatListBuilder` and styled via `CatListStyle`.

---

## Parameters

### CatList

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `items` | `[(content: CatListContent, action: () -> Void)]` | required | Array of row content/action pairs |
| `styleConfig` | `CatListStateStyleConfig` | `CatTheme.listConfig()` | Full interaction-state color matrix |

### CatListBuilder (single row)

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `content` | `CatListContent` | required | Row content: `.listItem` or `.avatarListItem` |
| `position` | `CatListPosition` | `.standalone` | Corner-radius position within a group |
| `styleConfig` | `CatListStateStyleConfig` | `CatTheme.listConfig()` | Full interaction-state color matrix |
| `action` | `() -> Void` | required | Closure invoked on tap |

---

## Content types

| Value | Description |
|-------|-------------|
| `.listItem(icon:title:newItemIndicator:)` | Standard navigation row with a leading icon, title, optional new-item indicator dot, and a trailing chevron |
| `.avatarListItem(initials:imageURL:color:title:subtitle:newItemIndicator:)` | Avatar navigation row with a leading `CatAvatarView`, title, optional subtitle, optional new-item indicator dot, and a trailing chevron |

---

## Position

`CatList` assigns positions automatically. Set `position` manually only when using `CatListBuilder` directly.

| Value | Description |
|-------|-------------|
| `.standalone` | Single isolated row — all four corners rounded |
| `.top` | First row in a group — top corners rounded, bottom corners square |
| `.middle` | Between two other rows — no corner rounding |
| `.bottom` | Last row in a group — bottom corners rounded, top corners square |

---

## Size

Row heights are fixed by content type:

| Content type | Height token | Value |
|--------------|-------------|-------|
| `.listItem` | `CatListSize.regular` | 56 pt |
| `.avatarListItem` | `CatListSize.medium` | 48 pt |

`CatListSize` also exposes `.extraSmall` (32 pt), `.small` (40 pt), and `.custom(CGFloat)` for custom row heights when building bespoke rows.

---

## Basic usage

```swift
// Single icon row
CatListBuilder(
    content: .listItem(
        icon: Image(systemName: "bookmark"),
        title: "Bookmarks",
        newItemIndicator: .constant(false)
    )
) {
    // action
}

// Group of rows — positions assigned automatically
CatList(items: [
    (
        .listItem(icon: Image(systemName: "bookmark"), title: "Bookmarks", newItemIndicator: .constant(false)),
        { }
    ),
    (
        .listItem(icon: Image(systemName: "gear"), title: "Settings", newItemIndicator: .constant(true)),
        { }
    ),
])
```

---

## Avatar rows

Use `.avatarListItem` to show a `CatAvatarView` as the leading element. `subtitle` is optional.

```swift
CatList(items: [
    (
        .avatarListItem(
            initials: "AB",
            imageURL: nil,
            color: CatColors.Theme.Primary.fill,
            title: "Alice Brown",
            subtitle: "iOS Developer",
            newItemIndicator: .constant(false)
        ),
        { }
    ),
    (
        .avatarListItem(
            initials: "CD",
            imageURL: URL(string: "https://example.com/avatar.jpg"),
            color: nil,
            title: "Chris Doe",
            subtitle: nil,
            newItemIndicator: .constant(true)
        ),
        { }
    ),
])
```

---

## New-item indicator

Pass a `Binding<Bool>` to `newItemIndicator`. When `true`, an indicator dot appears before the trailing chevron.

```swift
@State private var hasNew = true

CatList(items: [
    (
        .listItem(
            icon: Image(systemName: "bell"),
            title: "Notifications",
            newItemIndicator: $hasNew
        ),
        { hasNew = false }
    ),
])
```

---

## Disabled state

Apply `.disabled(true)` to `CatList` or `CatListBuilder` to render all rows with the disabled color style.

```swift
CatList(items: [...])
    .disabled(true)
```

---

## Custom style config

Provide a `CatListStateStyleConfig` to override colors for every interaction state.

```swift
let config = CatListStateStyleConfig(
    normal: CatListStateStyle(colorStyle: CatListStateColorStyle(
        background: .white,
        text: .black,
        subtitle: .gray,
        icon: .black,
        chevron: .gray,
        ellipse: .red,
        divider: Color(.separator)
    )),
    pressed: CatListStateStyle(colorStyle: CatListStateColorStyle(
        background: Color(.systemGray5),
        text: .black,
        subtitle: .gray,
        icon: .black,
        chevron: .gray,
        ellipse: .red,
        divider: Color(.separator)
    )),
    focused: CatListStateStyle(colorStyle: /* ... */),
    disabled: CatListStateStyle(colorStyle: /* ... */)
)

CatList(items: [...], styleConfig: config)
```

---

## Theme

```swift
VStack {
    CatList(items: [...])
}
.catalystTheme(.primaryHaiilo)
```
