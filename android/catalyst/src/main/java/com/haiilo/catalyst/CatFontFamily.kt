package com.haiilo.catalyst

import androidx.compose.ui.text.font.Font
import androidx.compose.ui.text.font.FontFamily

/**
 * Catalog of bundled / known font families, plus the currently active family
 * used by generated typography styles.
 *
 * [current] is the Android counterpart to iOS `CatTheme.fontFamily`: generated
 * `CatTypography` properties read it on every access, so swapping the app font
 * is a single assignment away (e.g. in `Application.onCreate`):
 *
 * ```kotlin
 * CatFontFamily.current = CatFontFamily.lato
 * // or, for a host-provided font registered on the device:
 * CatFontFamily.current = FontFamily(Font(DeviceFontFamilyName("HostFont")))
 * ```
 *
 * Font family *names* (as strings) are generated from design tokens into
 * `CatFontFamilyNames`. The `FontFamily` instances themselves stay here
 * because Compose needs either an `R.font.*` resource id or a
 * `DeviceFontFamilyName` — neither can live in a JSON token.
 */
object CatFontFamily {
    val lato: FontFamily = FontFamily(
        Font(R.font.lato)
    )

    /**
     * The active font family. Defaults to [lato]; override in app startup to
     * swap the typographic voice across every `CatTypography` style at once.
     */
    var current: FontFamily = lato
}
