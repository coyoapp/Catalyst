//
//  CatTheme.swift
//  Catalyst
//
//  Created by Efe Durmaz on 21.11.25.
//

import SwiftUI

public enum CatTheme {
    // MARK: - Theme Type
    /// Represents the available Catalyst themes.
    /// Currently only `.primaryHaiilo` is supported; additional cases can be added in future releases.
    public enum ThemeType: Hashable {
        case primaryHaiilo
        case dbEngage
    }

    // MARK: - Configuration
    /// Bootstrap entry point for host apps.
    ///
    /// Use this in `AppDelegate` / app startup to register Catalyst fonts and set the default theme
    /// for non-SwiftUI entry points. SwiftUI-based apps should use `.catalystTheme(_:)` on the
    /// root view to drive runtime theme switching; `configure()` remains the place to ensure fonts
    /// are registered exactly once at launch.
    /// - Parameter theme: The theme to activate. Defaults to `.primaryHaiilo`.
    public static func configure(theme: ThemeType = .primaryHaiilo) {
        current = theme
        CatFontRegistrar.registerFonts()
    }
    
    /// The theme that was selected during `configure(theme:)`. Defaults to `.primaryHaiilo`.
    public private(set) static var current: ThemeType = .primaryHaiilo

    // MARK: - Font family
    /// The font family associated with the active theme.
    ///
    /// Generated `CatTypography` reads this at call time, so flipping `current`
    /// swaps the typographic voice across the whole design system without
    /// touching individual call sites.
    public static var fontFamily: String {
        switch current {
        case .primaryHaiilo: return CatFontFamilies.lato
        case .dbEngage: return CatFontFamilies.dbEngage
        }
    }
    
    public enum ButtonVariant: Hashable {
        case filled
        case outlined
        case text
        case link
    }

    public enum ColorConfig: Hashable {
        case danger
        case info
        case primary
        case primaryInverted
        case secondary
        case secondaryInverted
        case success
        case warning

        /// Returns the `CatColorPalette` for this color role under the given theme.
        ///
        /// Resolved via `CatColorPalette.registry`. If the requested theme has no entry for
        /// this color (e.g. a new `ColorConfig` case was added but the registry wasn't updated),
        /// it falls back to the `.primaryHaiilo` palette for the same color rather than crashing.
        ///
        /// ```swift
        /// let palette = CatTheme.ColorConfig.danger.palette(for: .primaryHaiilo)
        /// button.backgroundColor = palette.bg    // always the right bg, right theme
        /// ```
        public func palette(for theme: ThemeType = .primaryHaiilo) -> CatColorPalette {
            // 1. Exact match for the requested theme + color.
            if let palette = CatColorPalette.registry[theme]?[self] { return palette }
            // 2. Requested theme exists but is missing this color — use primary as a safe stand-in.
            if let palette = CatColorPalette.registry[theme]?[.primary] { return palette }
            // 3. Ultimate fallback: primaryHaiilo primary. Registry is always required to have this.
            guard let palette = CatColorPalette.registry[.primaryHaiilo]?[.primary] else {
                fatalError("CatColorPalette.registry must always contain a .primaryHaiilo/.primary entry.")
            }
            return palette
        }
    }
    
    public enum AccentColorDarkenFactor: CGFloat {
        case hovered = 0.05
        case pressed = 0.11
    }
}
