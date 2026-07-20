//
//  CatTheme+SegmentedControl.swift
//  Catalyst
//

import SwiftUI

// MARK: - segmentedControlConfig

public extension CatTheme {

    /// Resolves a `CatSegmentedControlStyleConfig`.
    ///
    /// This is the single source of truth that maps design tokens onto the segmented
    /// control's colors. `CatSegmentedControl` calls this factory in its `body`.
    ///
    /// - Parameters:
    ///   - theme: The active theme. Defaults to `CatTheme.current`. Accepted for parity with
    ///     `CatTheme.buttonConfig`; the `CatColors.Theme.*` tokens are theme-agnostic today
    ///     (only `.primaryHaiilo` exists), so it does not yet branch on `theme`.
    ///   - accentPalette: An optional pre-resolved `CatColorPalette` injected via
    ///     `.catalystAccentColor(_:)`. When non-nil it overrides the Primary tokens for the
    ///     selected segment, enabling per-subtree whitelabeling. Accent palettes keep
    ///     `fill = .white`, so the selection pill stays white under any brand color — only
    ///     the selected label takes the accent. Track and unselected colors are unaffected.
    /// - Returns: A fully-resolved `CatSegmentedControlStyleConfig`.
    static func segmentedControlConfig(
        theme: ThemeType = CatTheme.current,
        accentPalette: CatColorPalette? = nil
    ) -> CatSegmentedControlStyleConfig {
        CatSegmentedControlStyleConfig(
            trackBackground: CatColors.Ui.Background.muted,
            selectedBackground: accentPalette?.fill ?? CatColors.Theme.Primary.fill,
            selectedText: accentPalette?.text ?? CatColors.Theme.Primary.text,
            unselectedText: CatColors.Ui.Font.muted
        )
    }
}
