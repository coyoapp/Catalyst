//
//  CatTheme+ToastMsg.swift
//  Catalyst
//
//  Created by Catalyst Agent on 2026-07-21.
//
//  !! GENERATED — REVIEW review.md THEN MOVE TO SOURCE !!
//  Destination: iOS/Catalyst/Sources/Catalyst/Theme/
//
//  Display profile — resolves a flat StyleConfig (no state machine).
//  Reference: CatTheme+Alert.swift
//

import SwiftUI

// MARK: - toastMsgConfig

public extension CatTheme {

    /// Resolves a `CatToastMsgStyleConfig`.
    ///
    /// This is the single source of truth that maps design tokens onto the
    /// toast's colors. `CatToastMsg` calls this factory in its `body`.
    ///
    /// The toast always uses the dark inverted surface (`surfaceInverted`) with
    /// inverted body text — there are no light/dark color variants. The accent
    /// palette only affects the action text color (`primaryInverted.text`), enabling
    /// per-subtree whitelabeling of the action affordance without changing the surface.
    ///
    /// - Parameters:
    ///   - theme: The active theme. Defaults to `CatTheme.current`.
    ///   - accentPalette: An optional pre-resolved `CatColorPalette` injected via
    ///     `.catalystAccentColor(_:)`. When non-nil, `actionColor` is taken from
    ///     `accentPalette.text` (the inverted-primary text token of the accent brand).
    ///     Surface and title colors are unaffected.
    /// - Returns: A fully-resolved `CatToastMsgStyleConfig`.
    static func toastMsgConfig(
        theme: ThemeType = CatTheme.current,
        accentPalette: CatColorPalette? = nil
    ) -> CatToastMsgStyleConfig {

        let actionColor = accentPalette?.text ?? CatColors.Theme.PrimaryInverted.text

        let colorStyle = CatToastMsgColorStyle(
            background: CatColors.Ui.Background.surfaceInverted,
            foreground: CatColors.Ui.Font.bodyInverted,
            actionColor: actionColor
        )

        return CatToastMsgStyleConfig(colorStyle: colorStyle)
    }
}
