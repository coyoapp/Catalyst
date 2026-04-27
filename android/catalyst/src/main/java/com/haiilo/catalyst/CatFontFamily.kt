package com.haiilo.catalyst

import androidx.compose.ui.text.font.Font
import androidx.compose.ui.text.font.FontFamily

/**
 * Catalog of bundled font families, plus the currently active family used by
 * generated typography styles.
 *
 * [current] is the Android counterpart to iOS `CatTheme.fontFamily`: generated
 * `CatTypography` properties read it on every access, so swapping the app font
 * is a single assignment away. Override it in your `Application.onCreate` before
 * `setContent` is called:
 *
 * ```kotlin
 * // Use a font bundled in your own app module's res/font/:
 * CatFontFamily.current = FontFamily(
 *     Font(R.font.wl_regular,        FontWeight.Normal),
 *     Font(R.font.wl_italic,         FontWeight.Normal, FontStyle.Italic),
 *     Font(R.font.wl_semibold,       FontWeight.SemiBold),
 *     Font(R.font.wl_semibold_italic, FontWeight.SemiBold, FontStyle.Italic),
 *     Font(R.font.wl_bold,           FontWeight.Bold),
 * )
 * ```
 *
 * Font family *names* (as strings) are generated from design tokens into
 * `CatFontFamilyNames`. The `FontFamily` instances themselves stay here (or in
 * the host app) because Compose needs either an `R.font.*` resource id or a
 * `DeviceFontFamilyName` — neither can live in a JSON token.
 */
object CatFontFamily {
    /**
     * Lato — bundled inside the Catalyst library. Always available as a
     * safe fallback even when no custom font is injected.
     */
    val lato: FontFamily = FontFamily(
        Font(R.font.lato)
    )

    /**
     * The active font family used by every [com.haiilo.catalyst.tokens.generated.CatTypography]
     * style. Defaults to [lato]. Override in `Application.onCreate` with your
     * brand's `FontFamily` built from TTFs bundled in your own app module.
     */
    var current: FontFamily = lato
}
