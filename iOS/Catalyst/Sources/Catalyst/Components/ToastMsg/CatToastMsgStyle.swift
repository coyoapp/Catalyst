//
//  CatToastMsgStyle.swift
//  Catalyst
//
//  Created by Catalyst Agent on 2026-07-21.
//
//  !! GENERATED — REVIEW review.md THEN MOVE TO SOURCE !!
//  Destination: iOS/Catalyst/Sources/Catalyst/Components/ToastMsgs/
//
//  Display profile — flat StyleConfig, no ButtonStyle, no state machine.
//  Reference: CatAlertStyle.swift
//

import SwiftUI

// MARK: - Variant

/// Layout mode for `CatToastMsg`.
///
/// - `compact`: Single-row layout. Icon + title + action + dismiss all inline.
///   Fixed height: 56 pt.
/// - `expanded`: Stacked layout. Title can wrap to multiple lines; action sits
///   below the title. Dismiss button stays anchored top-right. Fixed width 343 pt.
public enum CatToastMsgVariant: Hashable, CaseIterable {
    case compact
    case expanded
}

// MARK: - Color Style

/// Flat resolved color set for `CatToastMsg`.
///
/// The toast surface is non-interactive — only the consumer-supplied action slot
/// and the internal dismiss button are tappable. A single resolved color set is
/// sufficient; mirroring `CatButtonStateStyleConfig` here would be dead structure.
public struct CatToastMsgColorStyle: Sendable {
    /// Dark surface background.
    public let background: Color
    /// Inverted (light) foreground for the title and icon.
    public let foreground: Color
    /// Accent-aware color for the action button label.
    /// Derived from `primaryInverted.text`, overridable via `.catalystAccentColor(_:)`.
    public let actionColor: Color

    public init(background: Color, foreground: Color, actionColor: Color) {
        self.background = background
        self.foreground = foreground
        self.actionColor = actionColor
    }
}

// MARK: - Style Config

/// Everything `CatToastMsgBuilder` needs to render a `CatToastMsg`.
/// Produced by `CatTheme.toastMsgConfig(theme:accentPalette:)`.
public struct CatToastMsgStyleConfig: Sendable {
    public let colorStyle: CatToastMsgColorStyle
    public let cornerRadius: CGFloat
    /// Fixed width for the toast container (343 pt per brief spec).
    public let fixedWidth: CGFloat

    public init(
        colorStyle: CatToastMsgColorStyle,
        cornerRadius: CGFloat = CatBorderRadius.borderRadiusLg,
        fixedWidth: CGFloat = 343
    ) {
        self.colorStyle = colorStyle
        self.cornerRadius = cornerRadius
        self.fixedWidth = fixedWidth
    }
}
