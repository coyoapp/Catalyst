//
//  CatAlertStyle.swift
//  Catalyst
//

import SwiftUI

// MARK: - Variant

/// Semantic color role for a `CatAlert`. Drives the card border, the heading color,
/// and the leading-icon tint.
///
/// `.brand` is whitelabelable via `.catalystAccentColor(_:)` — when an accent palette is
/// present it overrides the Primary tokens, exactly like `CatButton`'s `.primary` role.
/// All other variants are unaffected by the accent color.
public enum CatAlertVariant: Hashable, CaseIterable {
    case info
    case success
    case warning
    case danger
    case neutral
    case brand
}

// MARK: - Resolved color style

/// The flat, fully-resolved color set for one alert.
///
/// `CatAlert` has **no** interaction-state matrix (normal/hovered/pressed/…): the card itself
/// is non-interactive — only the optional action button the consumer passes in is tappable, and
/// that button carries its own `CatButton` state styling. A single resolved color set is therefore
/// sufficient, and mirroring `CatButtonStateStyleConfig` here would be dead structure.
public struct CatAlertColorStyle: Sendable {
    /// Card border color.
    public let border: Color
    /// Heading text color.
    public let heading: Color
    /// Leading-icon tint.
    public let icon: Color
    /// Card background fill.
    public let background: Color

    public init(border: Color, heading: Color, icon: Color, background: Color) {
        self.border = border
        self.heading = heading
        self.icon = icon
        self.background = background
    }
}

// MARK: - Style config

/// Everything `CatAlertBuilder` needs to render a `CatAlert`. Produced by
/// `CatTheme.alertConfig(variant:theme:accentPalette:)`.
///
/// Colors come from `colorStyle`; the structural values default to design tokens so callers
/// almost never set them, but they stay overridable for forward-compatibility.
public struct CatAlertStyleConfig: Sendable {
    public let colorStyle: CatAlertColorStyle
    public let cornerRadius: CGFloat
    public let borderWidth: CGFloat
    public let headingFont: Font

    public init(
        colorStyle: CatAlertColorStyle,
        cornerRadius: CGFloat = CatBorderRadius.borderRadiusMd,
        borderWidth: CGFloat = CatBorderWidth.borderWidthDefault,
        headingFont: Font = CatTypography.body1
    ) {
        self.colorStyle = colorStyle
        self.cornerRadius = cornerRadius
        self.borderWidth = borderWidth
        self.headingFont = headingFont
    }
}
