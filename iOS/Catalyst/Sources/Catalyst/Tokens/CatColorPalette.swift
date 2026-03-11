//
//  CatColorPalette.swift
//  Catalyst
//
//  Created by Efe Durmaz on 06.13.26.
//

import SwiftUI

// MARK: - CatColorPalette

/// A concrete bag of the 9 semantic color slots that every `CatColors.Theme.*` group exposes.
///
/// Consumers read `palette.bg`, `palette.fill`, etc. without caring which token group or
/// theme produced the values. Adding a new theme only requires a new entry in `CatColorPalette.registry`
/// — no extensions, no per-component changes.
public struct CatColorPalette {
    public let bg: Color
    public let bgHover: Color
    public let bgActive: Color
    public let fill: Color
    public let fillHover: Color
    public let fillActive: Color
    public let text: Color
    public let textHover: Color
    public let textActive: Color
}

// MARK: - Registry

extension CatColorPalette {

    /// Central lookup table: `[ThemeType: [ColorConfig: CatColorPalette]]`.
    ///
    /// To add a new theme (e.g. `.dark`), append one block here pointing at the new
    /// `CatColors.DarkTheme.*` token groups. Nothing else in the codebase needs to change.
    ///
    /// ```swift
    /// // Adding dark theme — one new entry in this dictionary:
    /// .dark: [
    ///     .primary: .init(CatColors.DarkTheme.Primary.self),
    ///     .danger:  .init(CatColors.DarkTheme.Danger.self),
    ///     // ...
    /// ]
    /// ```
    static let registry: [CatTheme.ThemeType: [CatTheme.ColorConfig: CatColorPalette]] = [
        .primaryHaiilo: [
            .danger: .init(CatColors.Theme.Danger.self),
            .info: .init(CatColors.Theme.Info.self),
            .primary: .init(CatColors.Theme.Primary.self),
            .primaryInverted: .init(CatColors.Theme.PrimaryInverted.self),
            .secondary: .init(CatColors.Theme.Secondary.self),
            .secondaryInverted: .init(CatColors.Theme.SecondaryInverted.self),
            .success: .init(CatColors.Theme.Success.self),
            .warning: .init(CatColors.Theme.Warning.self)
        ]
    ]
}

// MARK: - CatThemeColorTokens protocol

/// Anything that provides the 9 standard semantic color slots.
/// Each `CatColors.Theme.*` enum conforms to this automatically via the extension below —
/// no manual conformance needed when new groups are added to the generated file.
public protocol CatThemeColorTokens {
    static var bg: Color { get }
    static var bgHover: Color { get }
    static var bgActive: Color { get }
    static var fill: Color { get }
    static var fillHover: Color { get }
    static var fillActive: Color { get }
    static var text: Color { get }
    static var textHover: Color { get }
    static var textActive: Color { get }
}

extension CatColors.Theme.Danger: CatThemeColorTokens {}
extension CatColors.Theme.Info: CatThemeColorTokens {}
extension CatColors.Theme.Primary: CatThemeColorTokens {}
extension CatColors.Theme.PrimaryInverted: CatThemeColorTokens {}
extension CatColors.Theme.Secondary: CatThemeColorTokens {}
extension CatColors.Theme.SecondaryInverted: CatThemeColorTokens {}
extension CatColors.Theme.Success: CatThemeColorTokens {}
extension CatColors.Theme.Warning: CatThemeColorTokens {}

extension CatColorPalette {
    /// Lifts any `CatThemeColorTokens`-conforming type into a `CatColorPalette` value.
    /// Used inside `registry` so each entry is a one-liner: `.init(CatColors.Theme.Danger.self)`.
    init<T: CatThemeColorTokens>(_ tokens: T.Type) {
        self.init(
            bg: T.bg,
            bgHover: T.bgHover,
            bgActive: T.bgActive,
            fill: T.fill,
            fillHover: T.fillHover,
            fillActive: T.fillActive,
            text: T.text,
            textHover: T.textHover,
            textActive: T.textActive
        )
    }

    /// Derives all 9 palette slots from a single arbitrary accent `Color`.
    ///
    /// This powers the whitelabeling path: clients pass one `Color` via
    /// `.catalystAccentColor(_:)` and every button variant (`.filled`, `.outlined`,
    /// `.text`, `.link`) automatically picks up correct hover/pressed states.
    ///
    /// - `bg` slots — used by the `.filled` variant background. Darkened on interaction
    ///   using `AccentColorDarkenFactor`.
    /// - `fill` slots — foreground *inside* a filled button. Kept white because accent
    ///   backgrounds are assumed to be dark enough to require white text (mirrors the
    ///   existing `Components.Buttons.Accent.filledConfig` behavior).
    /// - `text` slots — used by `.outlined`, `.text`, and `.link` variant foregrounds.
    ///   Normal state uses the accent color directly; hover/pressed darken it.
    init(accentColor: Color) {
        let hoverFactor  = CatTheme.AccentColorDarkenFactor.hovered.rawValue
        let activeFactor = CatTheme.AccentColorDarkenFactor.pressed.rawValue
        self.init(
            bg:          accentColor,
            bgHover:     accentColor.darken(by: hoverFactor),
            bgActive:    accentColor.darken(by: activeFactor),
            fill:        Color.white,
            fillHover:   Color.white,
            fillActive:  Color.white,
            text:        accentColor,
            textHover:   accentColor.darken(by: hoverFactor),
            textActive:  accentColor.darken(by: activeFactor)
        )
    }
}
