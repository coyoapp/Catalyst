//
//  CatTheme+Button.swift
//  Catalyst
//
//  Created by Efe Durmaz on 09.13.26.
//

import SwiftUI

// MARK: - buttonConfig

public extension CatTheme {

    /// Resolves a `CatButtonStateStyleConfig` for the given variant and color combination.
    ///
    /// This is the single source of truth that maps `(ButtonVariant × ColorConfig)` onto the
    /// design-token colors in `CatColors.Theme.*`. Use `.catButtonConfig(variant:color:)` on a
    /// view to inject this into the SwiftUI environment instead of passing `styleConfig:` directly.
    ///
    /// - Parameters:
    ///   - variant: The visual shape of the button (`.filled`, `.outlined`, `.text`, `.link`).
    ///   - color: The semantic color role from `CatColors.Theme` (`.primary`, `.danger`, etc.).
    ///   - theme: The active theme. Defaults to `CatTheme.current`. Pass explicitly if needed.
    ///   - accentPalette: An optional pre-resolved `CatColorPalette` injected via
    ///     `.catalystAccentColor(_:)`. When non-nil and `color == .primary`, this palette is used
    ///     instead of the registry entry, enabling per-subtree whitelabeling of primary buttons.
    ///     Buttons using other color roles are unaffected.
    /// - Returns: A fully-resolved `CatButtonStateStyleConfig` for all interaction states.
    static func buttonConfig(
        variant: ButtonVariant = .filled,
        color: ColorConfig = .primary,
        theme: ThemeType = CatTheme.current,
        accentPalette: CatColorPalette? = nil
    ) -> CatButtonStateStyleConfig {

        let p: CatColorPalette
        if color == .primary, let injected = accentPalette {
            p = injected
        } else {
            p = color.palette(for: theme)
        }

        // Shared disabled states — always muted regardless of variant/color.
        let disabledState = CatButtonStateStyle(
            colorStyle: CatButtonStateColorStyle(
                background: Color.clear,
                foreground: CatColors.Ui.Font.muted,
                border: Color.clear
            ),
            properties: CatStateProperties(isUnderlined: false, hasSecondaryFocusRing: false, scale: 1)
        )
        let filledDisabledState = CatButtonStateStyle(
            colorStyle: CatButtonStateColorStyle(
                background: CatColors.Ui.Background.muted,
                foreground: CatColors.Ui.Font.muted,
                border: Color.clear
            ),
            properties: CatStateProperties(isUnderlined: false, hasSecondaryFocusRing: false, scale: 1)
        )

        switch variant {

        // MARK: Filled — solid background, white fill
        case .filled:
            return CatButtonStateStyleConfig(
                normal: .init(
                    colorStyle: CatButtonStateColorStyle(background: p.bg, foreground: p.fill, border: Color.clear),
                    properties: CatStateProperties(isUnderlined: false, hasSecondaryFocusRing: false, scale: 1)
                ),
                hovered: .init(
                    colorStyle: CatButtonStateColorStyle(background: p.bgHover, foreground: p.fillHover, border: Color.clear),
                    properties: CatStateProperties(isUnderlined: false, hasSecondaryFocusRing: false, scale: 1)
                ),
                pressed: .init(
                    colorStyle: CatButtonStateColorStyle(background: p.bgActive, foreground: p.fillActive, border: Color.clear),
                    properties: CatStateProperties(isUnderlined: false, hasSecondaryFocusRing: false, scale: 1)
                ),
                focused: .init(
                    colorStyle: CatButtonStateColorStyle(background: p.bg, foreground: p.fill, border: Color.clear),
                    properties: CatStateProperties(isUnderlined: false, hasSecondaryFocusRing: true, scale: 1)
                ),
                disabled: filledDisabledState
            )

        // MARK: Outlined — transparent background, colored border and text
        case .outlined:
            return CatButtonStateStyleConfig(
                normal: .init(
                    colorStyle: CatButtonStateColorStyle(background: Color.clear, foreground: p.text, border: p.bg.opacity(0.20)),
                    properties: CatStateProperties(isUnderlined: false, hasSecondaryFocusRing: false, scale: 1)
                ),
                hovered: .init(
                    colorStyle: CatButtonStateColorStyle(background: p.bgHover.opacity(0.05), foreground: p.text, border: p.bg.opacity(0.20)),
                    properties: CatStateProperties(isUnderlined: false, hasSecondaryFocusRing: false, scale: 1)
                ),
                pressed: .init(
                    colorStyle: CatButtonStateColorStyle(background: p.bgActive.opacity(0.15), foreground: p.text, border: p.bg.opacity(0.20)),
                    properties: CatStateProperties(isUnderlined: false, hasSecondaryFocusRing: false, scale: 1)
                ),
                focused: .init(
                    colorStyle: CatButtonStateColorStyle(background: Color.clear, foreground: p.text, border: p.bg.opacity(0.20)),
                    properties: CatStateProperties(isUnderlined: false, hasSecondaryFocusRing: true, scale: 1)
                ),
                disabled: CatButtonStateStyle(
                    colorStyle: CatButtonStateColorStyle(
                        background: Color.clear,
                        foreground: CatColors.Ui.Font.muted,
                        border: CatColors.Ui.Font.muted.opacity(0.20)
                    ),
                    properties: CatStateProperties(isUnderlined: false, hasSecondaryFocusRing: false, scale: 1)
                )
            )

        // MARK: Text (ghost) — transparent background, no border, colored text
        case .text:
            return CatButtonStateStyleConfig(
                normal: .init(
                    colorStyle: CatButtonStateColorStyle(background: Color.clear, foreground: p.text, border: Color.clear),
                    properties: CatStateProperties(isUnderlined: false, hasSecondaryFocusRing: false, scale: 1)
                ),
                hovered: .init(
                    colorStyle: CatButtonStateColorStyle(background: p.bgHover.opacity(0.05), foreground: p.textHover, border: Color.clear),
                    properties: CatStateProperties(isUnderlined: false, hasSecondaryFocusRing: false, scale: 1)
                ),
                pressed: .init(
                    colorStyle: CatButtonStateColorStyle(background: p.bgActive.opacity(0.15), foreground: p.textActive, border: Color.clear),
                    properties: CatStateProperties(isUnderlined: false, hasSecondaryFocusRing: false, scale: 1)
                ),
                focused: .init(
                    colorStyle: CatButtonStateColorStyle(background: Color.clear, foreground: p.text, border: Color.clear),
                    properties: CatStateProperties(isUnderlined: false, hasSecondaryFocusRing: true, scale: 1)
                ),
                disabled: disabledState
            )

        // MARK: Link — transparent, no border, underline on hover/press
        case .link:
            return CatButtonStateStyleConfig(
                normal: .init(
                    colorStyle: CatButtonStateColorStyle(background: Color.clear, foreground: p.text, border: Color.clear),
                    properties: CatStateProperties(isUnderlined: false, hasSecondaryFocusRing: false, scale: 1)
                ),
                hovered: .init(
                    colorStyle: CatButtonStateColorStyle(background: Color.clear, foreground: p.textHover, border: Color.clear),
                    properties: CatStateProperties(isUnderlined: true, hasSecondaryFocusRing: false, scale: 1)
                ),
                pressed: .init(
                    colorStyle: CatButtonStateColorStyle(background: Color.clear, foreground: p.textActive, border: Color.clear),
                    properties: CatStateProperties(isUnderlined: true, hasSecondaryFocusRing: false, scale: 1)
                ),
                focused: .init(
                    colorStyle: CatButtonStateColorStyle(background: Color.clear, foreground: p.text, border: Color.clear),
                    properties: CatStateProperties(isUnderlined: false, hasSecondaryFocusRing: true, scale: 1)
                ),
                disabled: disabledState
            )
        }
    }
}
