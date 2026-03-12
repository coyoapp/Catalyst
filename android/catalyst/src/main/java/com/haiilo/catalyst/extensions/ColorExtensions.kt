package com.haiilo.catalyst.extensions

import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.toArgb
import androidx.core.graphics.ColorUtils
import androidx.core.graphics.toColorInt

// ---------------------------------------------------------------------------
// Color extensions
// ---------------------------------------------------------------------------

/**
 * Returns a darker version of this color by reducing HSL lightness by [by].
 *
 * [by] should be in 0f..1f (e.g. 0.05f = 5% darker). Values outside the
 * range are clamped so the result is always a valid color.
 */
fun Color.darken(by: Float): Color {
    val hsl = FloatArray(3)
    ColorUtils.colorToHSL(toArgb(), hsl)
    hsl[2] = (hsl[2] - by).coerceIn(0f, 1f)
    return Color(ColorUtils.HSLToColor(hsl))
}

/**
 * Parses a hex color string into a Compose [Color].
 *
 * Accepts `"#RRGGBB"` and `"#AARRGGBB"` formats, which are the two formats
 * used in Android `colors.xml` and `strings.xml` resources.
 *
 * Throws [IllegalArgumentException] on malformed input — same contract as
 * [android.graphics.Color.parseColor].
 *
 * ```kotlin
 * // colors.xml:  <color name="brand_accent">#FF1A73E8</color>
 * // strings.xml: <string name="brand_accent_hex">#1A73E8</string>
 * val color = Color.parseHex(getString(R.string.brand_accent_hex))
 * ```
 */
fun Color.Companion.parseHex(hex: String): Color = Color(hex.toColorInt())
