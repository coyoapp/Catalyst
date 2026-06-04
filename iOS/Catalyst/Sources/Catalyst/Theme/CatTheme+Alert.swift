//
//  CatTheme+Alert.swift
//  Catalyst
//

import SwiftUI

// MARK: - alertConfig

public extension CatTheme {

    /// Resolves a `CatAlertStyleConfig` for the given alert variant.
    ///
    /// This is the single source of truth that maps `CatAlertVariant` onto the design-token
    /// colors in `CatColors.*`. Use `.catAlertConfig(variant:)` on a view to inject the variant
    /// into the SwiftUI environment; `CatAlert` calls this factory to resolve the colors.
    ///
    /// - Parameters:
    ///   - variant: The semantic color role of the alert.
    ///   - theme: The active theme. Defaults to `CatTheme.current`. Accepted for parity with
    ///     `CatTheme.buttonConfig`; the `CatColors.Theme.*` tokens are theme-agnostic today
    ///     (only `.primaryHaiilo` exists), so it does not yet branch on `theme`.
    ///   - accentPalette: An optional pre-resolved `CatColorPalette` injected via
    ///     `.catalystAccentColor(_:)`. When non-nil it overrides the `.brand` variant's Primary
    ///     tokens, enabling per-subtree whitelabeling. Other variants are unaffected.
    /// - Returns: A fully-resolved `CatAlertStyleConfig`.
    static func alertConfig(
        variant: CatAlertVariant,
        theme: ThemeType = CatTheme.current,
        accentPalette: CatColorPalette? = nil
    ) -> CatAlertStyleConfig {

        // All variants sit on the standard surface.
        let background = CatColors.Ui.Background.surface

        let colorStyle: CatAlertColorStyle

        switch variant {

        case .info:
            colorStyle = CatAlertColorStyle(
                border: CatColors.Theme.Info.bg,
                heading: CatColors.Theme.Info.text,
                icon: CatColors.Theme.Info.text,
                background: background
            )

        case .success:
            colorStyle = CatAlertColorStyle(
                border: CatColors.Theme.Success.bg,
                heading: CatColors.Theme.Success.text,
                icon: CatColors.Theme.Success.text,
                background: background
            )

        case .warning:
            // Warning `.bg` (#FFCE80) is too pale to read as a 1pt border, so the legible
            // `.text` amber (#9F6100) is used for border, heading, and icon alike.
            colorStyle = CatAlertColorStyle(
                border: CatColors.Theme.Warning.text,
                heading: CatColors.Theme.Warning.text,
                icon: CatColors.Theme.Warning.text,
                background: background
            )

        case .danger:
            colorStyle = CatAlertColorStyle(
                border: CatColors.Theme.Danger.bg,
                heading: CatColors.Theme.Danger.text,
                icon: CatColors.Theme.Danger.text,
                background: background
            )

        case .neutral:
            // No semantic Theme group — uses the generic UI border + body font tokens.
            colorStyle = CatAlertColorStyle(
                border: CatColors.Ui.Border.dark,
                heading: CatColors.Ui.Font.body,
                icon: CatColors.Ui.Font.body,
                background: background
            )

        case .brand:
            // Whitelabel path — same shape as `CatTheme.buttonConfig` (variant .brand ⇄ color .primary).
            if let injected = accentPalette {
                colorStyle = CatAlertColorStyle(
                    border: injected.bg,
                    heading: injected.text,
                    icon: injected.text,
                    background: background
                )
            } else {
                colorStyle = CatAlertColorStyle(
                    border: CatColors.Theme.Primary.bg,
                    heading: CatColors.Theme.Primary.text,
                    icon: CatColors.Theme.Primary.text,
                    background: background
                )
            }
        }

        return CatAlertStyleConfig(colorStyle: colorStyle)
    }
}
