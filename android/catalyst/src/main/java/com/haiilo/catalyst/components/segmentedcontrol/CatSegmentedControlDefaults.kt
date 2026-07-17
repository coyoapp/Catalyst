package com.haiilo.catalyst.components.segmentedcontrol

import androidx.compose.ui.graphics.Color
import com.haiilo.catalyst.theme.CatColorPalette
import com.haiilo.catalyst.tokens.generated.CatColors

// ---------------------------------------------------------------------------
// CatSegmentedControlDefaults
//
// Single source of truth that maps CatSegmentedControlColor to the design-token
// colors used by the control.
// ---------------------------------------------------------------------------

object CatSegmentedControlDefaults {
    private const val PressedSurfaceAlpha = 0.72f

    /**
     * Resolves the colors for a segmented control.
     *
     * When [accentPalette] is non-null and [color] is
     * [CatSegmentedControlColor.Primary], the accent palette overrides the
     * default primary token palette. All other color roles are unaffected.
     */
    fun colors(
        color: CatSegmentedControlColor,
        accentPalette: CatColorPalette? = null,
    ): CatSegmentedControlColors {
        val palette = if (accentPalette != null && color == CatSegmentedControlColor.Primary) {
            accentPalette
        } else {
            color.palette()
        }

        return CatSegmentedControlColors(
            containerBackground = CatColors.Ui.Background.muted,
            containerBorder = Color.Transparent,
            itemColors = CatSegmentedControlItemStateColors(
                selected = CatSegmentedControlSegmentColors(
                    background = CatColors.Ui.Background.surface,
                    foreground = palette.text,
                ),
                selectedPressed = CatSegmentedControlSegmentColors(
                    background = CatColors.Ui.Background.surface,
                    foreground = palette.textActive,
                ),
                unselected = CatSegmentedControlSegmentColors(
                    background = Color.Transparent,
                    foreground = CatColors.Ui.Font.muted,
                ),
                unselectedPressed = CatSegmentedControlSegmentColors(
                    background = CatColors.Ui.Background.surface
                        .copy(alpha = PressedSurfaceAlpha),
                    foreground = palette.textActive,
                ),
                disabled = CatSegmentedControlSegmentColors(
                    background = CatColors.Ui.Background.muted,
                    foreground = CatColors.Ui.Font.muted,
                ),
            ),
        )
    }
}

internal fun CatSegmentedControlColor.palette(): CatColorPalette =
    when (this) {
        CatSegmentedControlColor.Primary -> CatColorPalette.Primary
        CatSegmentedControlColor.PrimaryInverted -> CatColorPalette.PrimaryInverted
        CatSegmentedControlColor.Secondary -> CatColorPalette.Secondary
        CatSegmentedControlColor.SecondaryInverted -> CatColorPalette.SecondaryInverted
        CatSegmentedControlColor.Danger -> CatColorPalette.Danger
        CatSegmentedControlColor.Success -> CatColorPalette.Success
        CatSegmentedControlColor.Warning -> CatColorPalette.Warning
        CatSegmentedControlColor.Info -> CatColorPalette.Info
    }
