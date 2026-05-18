//
//  CatListStyle.swift
//  Catalyst
//
//  Created by Efe Durmaz on 04.05.26.
//

import SwiftUI

// MARK: - List Position

/// Describes where a list item sits within a group, driving corner-radius clipping.
///
/// Use `.standalone` for a single isolated item, `.top` / `.middle` / `.bottom`
/// for consecutive items in a group. The `CatList` container assigns positions
/// automatically; only set this manually when composing `CatListBuilder` directly.
public enum CatListPosition {
    /// The only item in a group — all four corners are rounded.
    case standalone
    /// The first item in a multi-item group — top corners rounded, bottom corners square.
    case top
    /// An item between two others — no corner rounding (plain rectangle).
    case middle
    /// The last item in a multi-item group — bottom corners rounded, top corners square.
    case bottom

    /// Per-corner radii used to clip and shape the row.
    var cornerRadii: RectangleCornerRadii {
        let borderRadius = CatBorderRadius.borderRadiusMd
        switch self {
        case .standalone:
            return RectangleCornerRadii(
                topLeading: borderRadius,
                bottomLeading: borderRadius,
                bottomTrailing: borderRadius,
                topTrailing: borderRadius
            )
        case .top:
            return RectangleCornerRadii(
                topLeading: borderRadius,
                bottomLeading: 0,
                bottomTrailing: 0,
                topTrailing: borderRadius
            )
        case .middle:
            return RectangleCornerRadii(
                topLeading: 0,
                bottomLeading: 0,
                bottomTrailing: 0,
                topTrailing: 0
            )
        case .bottom:
            return RectangleCornerRadii(
                topLeading: 0,
                bottomLeading: borderRadius,
                bottomTrailing: borderRadius,
                topTrailing: 0
            )
        }
    }

    /// Whether a divider line should appear above the text/trailing area of this row.
    /// Dividers separate consecutive rows but never appear on the first row of a group.
    var showDivider: Bool {
        switch self {
        case .standalone, .bottom: return false
        case .middle, .top: return true
        }
    }
}

// MARK: - List State Color Style

/// The complete set of colors for a single interaction state of a navigation list row.
///
/// One `CatListStateColorStyle` is defined per state (normal, hovered, pressed, focused,
/// disabled). `CatListStyle` resolves the active state and injects the winning
/// `CatListStateColorStyle` into the SwiftUI environment so every sub-view in the row
/// (icon, title, chevron, divider) can read its specific color slot independently.
public struct CatListStateColorStyle: Sendable {
    /// Row background fill.
    public let background: Color
    /// Title (and subtitle) text color.
    public let text: Color
    /// Subtitle text color.
    public let subtitle: Color
    /// Leading icon tint.
    public let icon: Color
    /// Trailing chevron tint.
    public let chevron: Color
    /// New-item indicator dot tint.
    public let ellipse: Color
    /// Inter-row divider line color.
    public let divider: Color

    public init(
        background: Color,
        text: Color,
        subtitle: Color,
        icon: Color,
        chevron: Color,
        ellipse: Color,
        divider: Color
    ) {
        self.background = background
        self.text = text
        self.icon = icon
        self.chevron = chevron
        self.ellipse = ellipse
        self.divider = divider
        self.subtitle = subtitle
    }
}

// MARK: - List State Style

/// Bundles a `CatListStateColorStyle` for one interaction state.
/// Reserved for future per-state property extensions (e.g. scale, opacity).
public struct CatListStateStyle: Sendable {
    public let colorStyle: CatListStateColorStyle

    public init(colorStyle: CatListStateColorStyle) {
        self.colorStyle = colorStyle
    }
}

// MARK: - List State Style Config

/// The full interaction-state matrix for a navigation list row.
///
/// Pass this to `CatListBuilder` or `CatList` directly, or produce one via
/// `CatTheme.listConfig()`. `CatListStyle` reads this config and resolves
/// the active `CatListStateStyle` on every render.
public struct CatListStateStyleConfig: Sendable {
    /// Default resting appearance.
    public let normal: CatListStateStyle
    /// Cursor-hover appearance (macOS / iPadOS pointer). Falls back to `normal` when `nil`.
    public let hovered: CatListStateStyle?
    /// Tap / click down appearance.
    public let pressed: CatListStateStyle
    /// Keyboard-focus / accessibility-focus appearance.
    public let focused: CatListStateStyle
    /// Non-interactive appearance when `.disabled(true)` is applied.
    public let disabled: CatListStateStyle

    public init(
        normal: CatListStateStyle,
        hovered: CatListStateStyle? = nil,
        pressed: CatListStateStyle,
        focused: CatListStateStyle,
        disabled: CatListStateStyle
    ) {
        self.normal = normal
        self.hovered = hovered
        self.pressed = pressed
        self.focused = focused
        self.disabled = disabled
    }
}

// MARK: - Environment Bridge

/// Internal environment key that carries the resolved `CatListStateColorStyle`
/// from `CatListStyle` down into `CatListBuilder`'s row sub-views.
struct CatListResolvedStyleKey: EnvironmentKey {
    static let defaultValue = CatListStateColorStyle(
        background: CatColors.Theme.Primary.fill,
        text: CatColors.Ui.Font.body,
        subtitle: CatColors.Ui.Font.muted,
        icon: CatColors.Ui.Font.body,
        chevron: CatColors.Ui.Font.muted,
        ellipse: CatColors.Theme.Danger.bg,
        divider: CatColors.Ui.Border.regular
    )
}

extension EnvironmentValues {
    var catListResolvedStyle: CatListStateColorStyle {
        get { self[CatListResolvedStyleKey.self] }
        set { self[CatListResolvedStyleKey.self] = newValue }
    }
}

// MARK: - List Size

public enum CatListSize {
    case extraSmall
    case small
    case medium
    case regular
    case custom(CGFloat)

    var height: CGFloat {
        switch self {
        case .extraSmall: return CatSizes.sizeXl   // 32
        case .small: return CatSizes.size2xl  // 40
        case .medium: return CatSizes.size3xl  // 48
        case .regular: return CatSizes.size4xl // 56
        case .custom(let cusomHeight): return cusomHeight
        }
    }
}

// MARK: - List Content

public enum CatListContent {
    /// Standard navigation row: leading icon, title, optional new-item indicator, chevron.
    case listItem(icon: Image, title: String, newItemIndicator: Binding<Bool>)
    /// Avatar navigation row: leading `CatAvatarView`, title, optional new-item indicator, chevron.
    case avatarListItem(initials: String?, imageURL: URL?, backgroundColor: Color?, title: String, subtitle: String?, newItemIndicator: Binding<Bool>)
}

// MARK: - List Style

/// Resolves the active interaction state from `CatListStateStyleConfig`, injects the
/// winning `CatListStateColorStyle` into the SwiftUI environment, and clips the row
/// to its position-aware `UnevenRoundedRectangle` shape.
///
/// Internal layout (divider, icon, title, chevron) is handled by `CatListBuilder`,
/// which reads colors from `@Environment(\.catListResolvedStyle)`.
public struct CatListStyle: ButtonStyle {
    let styleConfig: CatListStateStyleConfig
    let position: CatListPosition

    var isLoading: Bool = false
    @State private var isHovered: Bool = false
    @Environment(\.isFocused) private var isFocused
    @Environment(\.isEnabled) private var isEnabled

    public func makeBody(configuration: Configuration) -> some View {
        let resolved = resolveState(isPressed: configuration.isPressed)
        let clipShape = UnevenRoundedRectangle(cornerRadii: position.cornerRadii)

        configuration.label
            .frame(maxWidth: .infinity)
            .background(resolved.colorStyle.background)
            .environment(\.catListResolvedStyle, resolved.colorStyle)
            .clipShape(clipShape)
            .contentShape(clipShape)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
            .onHover { isHovered = $0 }
    }

    // MARK: State resolution

    /// Priority: disabled → pressed → hovered → focused → normal
    private func resolveState(isPressed: Bool) -> CatListStateStyle {
        guard isEnabled else { return styleConfig.disabled }
        if isPressed { return styleConfig.pressed }
        if isHovered, let hovered = styleConfig.hovered { return hovered }
        if isFocused { return styleConfig.focused }
        return styleConfig.normal
    }
}
