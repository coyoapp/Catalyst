package com.haiilo.catalyst.components.segmentedtoggle

import androidx.compose.ui.graphics.Color
import com.haiilo.catalyst.theme.CatColorPalette
import com.haiilo.catalyst.tokens.generated.CatColors

// ---------------------------------------------------------------------------
// CatSegmentedToggleDefaults
//
// Single source of truth that maps CatSegmentedToggleColor to the design-token
// colors used by the control.
// ---------------------------------------------------------------------------

object CatSegmentedToggleDefaults {
    private const val PressedSurfaceAlpha = 0.72f

    /**
     * Resolves the colors for a segmented toggle.
     *
     * When [accentPalette] is non-null and [color] is
     * [CatSegmentedToggleColor.Primary], the accent palette overrides the
     * default primary token palette. All other color roles are unaffected.
     */
    fun colors(
        color: CatSegmentedToggleColor,
        accentPalette: CatColorPalette? = null,
    ): CatSegmentedToggleColors {
        val palette = if (accentPalette != null && color == CatSegmentedToggleColor.Primary) {
            accentPalette
        } else {
            color.palette()
        }

        return CatSegmentedToggleColors(
            containerBackground = CatColors.Ui.Background.muted,
            containerBorder = CatColors.Ui.Border.regular,
            itemColors = CatSegmentedToggleItemStateColors(
                selected = CatSegmentedToggleSegmentColors(
                    background = CatColors.Ui.Background.surface,
                    foreground = palette.text,
                ),
                selectedPressed = CatSegmentedToggleSegmentColors(
                    background = CatColors.Ui.Background.surface,
                    foreground = palette.textActive,
                ),
                selectedDisabled = CatSegmentedToggleSegmentColors(
                    background = CatColors.Ui.Background.surface,
                    foreground = CatColors.Ui.Font.muted,
                ),
                unselected = CatSegmentedToggleSegmentColors(
                    background = Color.Transparent,
                    foreground = CatColors.Ui.Font.muted,
                ),
                unselectedPressed = CatSegmentedToggleSegmentColors(
                    background = CatColors.Ui.Background.surface
                        .copy(alpha = PressedSurfaceAlpha),
                    foreground = palette.textActive,
                ),
                unselectedDisabled = CatSegmentedToggleSegmentColors(
                    background = Color.Transparent,
                    foreground = CatColors.Ui.Font.muted,
                ),
            ),
        )
    }
}

internal fun CatSegmentedToggleColor.palette(): CatColorPalette =
    when (this) {
        CatSegmentedToggleColor.Primary -> CatColorPalette.Primary
        CatSegmentedToggleColor.PrimaryInverted -> CatColorPalette.PrimaryInverted
        CatSegmentedToggleColor.Secondary -> CatColorPalette.Secondary
        CatSegmentedToggleColor.SecondaryInverted -> CatColorPalette.SecondaryInverted
        CatSegmentedToggleColor.Danger -> CatColorPalette.Danger
        CatSegmentedToggleColor.Success -> CatColorPalette.Success
        CatSegmentedToggleColor.Warning -> CatColorPalette.Warning
        CatSegmentedToggleColor.Info -> CatColorPalette.Info
    }
