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

        let colorPalatte: CatColorPalette
        if color == .primary, let injected = accentPalette {
            colorPalatte = injected
        } else {
            colorPalatte = color.palette(for: theme)
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

        switch variant {

        // MARK: Filled — solid background, white fill
        case .filled:
            return CatButtonStateStyleConfig(
                normal: .init(
                    colorStyle: CatButtonStateColorStyle(background: colorPalatte.bg, foreground: colorPalatte.fill, border: Color.clear),
                    properties: CatStateProperties(isUnderlined: false, hasSecondaryFocusRing: false, scale: 1)
                ),
                hovered: .init(
                    colorStyle: CatButtonStateColorStyle(background: colorPalatte.bgHover, foreground: colorPalatte.fillHover, border: Color.clear),
                    properties: CatStateProperties(isUnderlined: false, hasSecondaryFocusRing: false, scale: 1)
                ),
                pressed: .init(
                    colorStyle: CatButtonStateColorStyle(background: colorPalatte.bgActive, foreground: colorPalatte.fillActive, border: Color.clear),
                    properties: CatStateProperties(isUnderlined: false, hasSecondaryFocusRing: false, scale: 1)
                ),
                focused: .init(
                    colorStyle: CatButtonStateColorStyle(background: colorPalatte.bg, foreground: colorPalatte.fill, border: Color.clear),
                    properties: CatStateProperties(isUnderlined: false, hasSecondaryFocusRing: true, scale: 1)
                ),
                disabled: CatButtonStateStyle(
                    colorStyle: CatButtonStateColorStyle(
                        background: CatColors.Ui.Background.muted,
                        foreground: CatColors.Ui.Font.muted,
                        border: Color.clear
                    ),
                    properties: CatStateProperties(isUnderlined: false, hasSecondaryFocusRing: false, scale: 1)
                )
            )

        // MARK: Outlined — transparent background, colored border and text
        case .outlined:
            return CatButtonStateStyleConfig(
                normal: .init(
                    colorStyle: CatButtonStateColorStyle(background: Color.clear, foreground: colorPalatte.text, border: colorPalatte.bg.opacity(0.20)),
                    properties: CatStateProperties(isUnderlined: false, hasSecondaryFocusRing: false, scale: 1)
                ),
                hovered: .init(
                    colorStyle: CatButtonStateColorStyle(background: colorPalatte.bgHover.opacity(0.05), foreground: colorPalatte.text, border: colorPalatte.bg.opacity(0.20)),
                    properties: CatStateProperties(isUnderlined: false, hasSecondaryFocusRing: false, scale: 1)
                ),
                pressed: .init(
                    colorStyle: CatButtonStateColorStyle(background: colorPalatte.bgActive.opacity(0.15), foreground: colorPalatte.text, border: colorPalatte.bg.opacity(0.20)),
                    properties: CatStateProperties(isUnderlined: false, hasSecondaryFocusRing: false, scale: 1)
                ),
                focused: .init(
                    colorStyle: CatButtonStateColorStyle(background: Color.clear, foreground: colorPalatte.text, border: colorPalatte.bg.opacity(0.20)),
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
                    colorStyle: CatButtonStateColorStyle(background: Color.clear, foreground: colorPalatte.text, border: Color.clear),
                    properties: CatStateProperties(isUnderlined: false, hasSecondaryFocusRing: false, scale: 1)
                ),
                hovered: .init(
                    colorStyle: CatButtonStateColorStyle(background: colorPalatte.bgHover.opacity(0.05), foreground: colorPalatte.textHover, border: Color.clear),
                    properties: CatStateProperties(isUnderlined: false, hasSecondaryFocusRing: false, scale: 1)
                ),
                pressed: .init(
                    colorStyle: CatButtonStateColorStyle(background: colorPalatte.bgActive.opacity(0.15), foreground: colorPalatte.textActive, border: Color.clear),
                    properties: CatStateProperties(isUnderlined: false, hasSecondaryFocusRing: false, scale: 1)
                ),
                focused: .init(
                    colorStyle: CatButtonStateColorStyle(background: Color.clear, foreground: colorPalatte.text, border: Color.clear),
                    properties: CatStateProperties(isUnderlined: false, hasSecondaryFocusRing: true, scale: 1)
                ),
                disabled: disabledState
            )

        // MARK: Link — transparent, no border, underline on hover/press
        case .link:
            return CatButtonStateStyleConfig(
                normal: .init(
                    colorStyle: CatButtonStateColorStyle(background: Color.clear, foreground: colorPalatte.text, border: Color.clear),
                    properties: CatStateProperties(isUnderlined: false, hasSecondaryFocusRing: false, scale: 1)
                ),
                hovered: .init(
                    colorStyle: CatButtonStateColorStyle(background: Color.clear, foreground: colorPalatte.textHover, border: Color.clear),
                    properties: CatStateProperties(isUnderlined: true, hasSecondaryFocusRing: false, scale: 1)
                ),
                pressed: .init(
                    colorStyle: CatButtonStateColorStyle(background: Color.clear, foreground: colorPalatte.textActive, border: Color.clear),
                    properties: CatStateProperties(isUnderlined: true, hasSecondaryFocusRing: false, scale: 1)
                ),
                focused: .init(
                    colorStyle: CatButtonStateColorStyle(background: Color.clear, foreground: colorPalatte.text, border: Color.clear),
                    properties: CatStateProperties(isUnderlined: false, hasSecondaryFocusRing: true, scale: 1)
                ),
                disabled: disabledState
            )
        }
    }
}
