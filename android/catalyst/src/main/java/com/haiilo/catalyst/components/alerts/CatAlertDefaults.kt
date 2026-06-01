package com.haiilo.catalyst.components.alerts

import com.haiilo.catalyst.theme.CatColorPalette
import com.haiilo.catalyst.tokens.generated.CatColors


// ---------------------------------------------------------------------------
// CatAlertDefaults
//
// Single source of truth that maps CatAlertColor → CatAlertColors using the
// existing CatColors design tokens. Mirrors the same pattern as
// CatButtonDefaults in the buttons package.
// ---------------------------------------------------------------------------

object CatAlertDefaults {
    private const val BorderAlpha = 0.30f

    /**
     * Resolves the [CatAlertColors] for the given [color] role.
     *
     * Border, icon, and text all share the semantic `.text` token of the
     * corresponding theme group so the alert reads as a coherent, single-
     * color card. The [CatAlertColor.Default] variant uses the neutral UI
     * border and font tokens instead.
     */
    fun colors(
        color: CatAlertColor,
        accentPalette: CatColorPalette? = null,
    ): CatAlertColors {
        if (color == CatAlertColor.Default) {
            return CatAlertColors(
                border = CatColors.Ui.Border.dark.copy(alpha = BorderAlpha),
                icon = CatColors.Ui.Font.body,
                text = CatColors.Ui.Font.body,
            )
        }

        val palette = if (accentPalette != null && color == CatAlertColor.Primary) {
            accentPalette
        } else {
            color.palette()
        }

        return CatAlertColors(
            border = palette.text.copy(alpha = BorderAlpha),
            icon = palette.text,
            text = palette.text,
        )
    }
}

internal fun CatAlertColor.palette(): CatColorPalette =
    when (this) {
        CatAlertColor.Primary -> CatColorPalette.Primary
        CatAlertColor.Info -> CatColorPalette.Info
        CatAlertColor.Success -> CatColorPalette.Success
        CatAlertColor.Warning -> CatColorPalette.Warning
        CatAlertColor.Danger -> CatColorPalette.Danger
        CatAlertColor.Default -> error("Default alert color is resolved via UI tokens")
    }
