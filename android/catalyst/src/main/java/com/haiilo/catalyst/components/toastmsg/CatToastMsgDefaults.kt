// CatToastMsgDefaults.kt
// Catalyst
//
// Created by Catalyst Agent on 2026-07-21.
//
// Display profile — colors() factory resolves CatToastMsgColors from tokens.
// Reference: CatAlertDefaults.kt

package com.haiilo.catalyst.components.toastmsg

import com.haiilo.catalyst.theme.CatColorPalette
import com.haiilo.catalyst.tokens.generated.CatColors

// ---------------------------------------------------------------------------
// CatToastMsgDefaults
//
// Single source of truth that maps design tokens onto toast colors.
//
// The toast always uses the dark inverted surface — there are no color variants.
// The accent palette only affects the action text color (primaryInverted.text),
// enabling per-subtree whitelabeling without changing the surface.
// ---------------------------------------------------------------------------

object CatToastMsgDefaults {
    /**
     * Resolves [CatToastMsgColors] for the toast.
     *
     * When [accentPalette] is non-null, [CatToastMsgColors.actionColor] is taken
     * from `accentPalette.text`, enabling whitelabeling of the action affordance.
     * Surface and title colors are always the dark inverted tokens.
     */
    fun colors(accentPalette: CatColorPalette? = null): CatToastMsgColors {
        val actionColor = accentPalette?.text
            ?: CatColors.Theme.PrimaryInverted.text

        return CatToastMsgColors(
            background = CatColors.Ui.Background.surfaceInverted,
            foreground = CatColors.Ui.Font.bodyInverted,
            actionColor = actionColor,
        )
    }
}
