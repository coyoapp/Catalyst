package com.haiilo.catalyst.theme

import androidx.compose.ui.graphics.Color
import com.haiilo.catalyst.extensions.parseHex

// ---------------------------------------------------------------------------
// CatThemeConfig
//
// One-time configuration object for app-level Catalyst theming. Call
// configure() before setContent {} in Application.onCreate() or
// Activity.onCreate() to set a brand accent color that all CatButtons will
// pick up automatically via CatTheme + LocalCatAccentPalette.
//
// Only CatButtonColor.Primary is overridden — all other color roles
// (Danger, Success, etc.) continue to use their design-token palettes.
//
// Mirrors CatTheme.buttonConfig(variant:color:accentPalette:) on iOS.
//
// Usage (Application.onCreate or Activity.onCreate, before setContent):
//
//   // From a Color value:
//   CatThemeConfig.configure(Color(0xFF1A73E8))
//
//   // From a strings.xml / colors.xml hex string:
//   CatThemeConfig.configure(getString(R.string.brand_accent_hex))
// ---------------------------------------------------------------------------

object CatThemeConfig {
    internal var accentPalette: CatColorPalette? = null
        private set

    /**
     * Sets the app-wide accent color from a Compose [Color].
     *
     * Call this before [androidx.activity.compose.setContent] so the palette
     * is available when [CatTheme] first composes.
     */
    fun configure(accentColor: Color) {
        accentPalette = CatColorPalette.fromAccentColor(accentColor)
    }

    /**
     * Sets the app-wide accent color from a hex string.
     *
     * Accepts `"#RRGGBB"` and `"#AARRGGBB"` — the two formats used in
     * Android `strings.xml` and `colors.xml` resources.
     *
     * ```kotlin
     * // strings.xml: <string name="brand_accent">#1A73E8</string>
     * CatThemeConfig.configure(getString(R.string.brand_accent))
     * ```
     *
     * @throws IllegalArgumentException if [accentHex] is not a valid hex color.
     */
    fun configure(accentHex: String) {
        accentPalette = CatColorPalette.fromAccentColor(Color.parseHex(accentHex))
    }
}
