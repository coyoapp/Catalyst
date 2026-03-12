package com.haiilo.catalyst.components.buttons

import androidx.compose.ui.graphics.Color
import com.haiilo.catalyst.tokens.CatColorPalette
import com.haiilo.catalyst.tokens.generated.CatColors

// ---------------------------------------------------------------------------
// CatButtonDefaults
//
// Single source of truth that maps (CatButtonVariant × CatButtonColor)
// onto the design-token colors in CatColors.Theme.*.
// ---------------------------------------------------------------------------

object CatButtonDefaults {
    // -----------------------------------------------------------------------
    // Public API
    // -----------------------------------------------------------------------

    /**
     * Resolves a [CatButtonState] for the given [variant] and
     * [color] combination. This is the single source of truth that maps
     * every (variant × color) pair onto the design-token colors.
     */
    fun style(
        variant: CatButtonVariant,
        color: CatButtonColor,
    ): CatButtonState {
        val p = color.palette()
        return when (variant) {
            CatButtonVariant.Filled -> filledConfig(p)
            CatButtonVariant.Outlined -> outlinedConfig(p)
            CatButtonVariant.Text -> textConfig(p)
            CatButtonVariant.Link -> linkConfig(p)
        }
    }

    // -----------------------------------------------------------------------
    // Variant builders
    // -----------------------------------------------------------------------

    // MARK: Filled — solid background, filled foreground
    private fun filledConfig(p: CatColorPalette): CatButtonState {
        val disabledState = CatButtonStateStyle(
            colorStyle = CatButtonStateColorStyle(
                background = CatColors.Ui.Background.muted,
                foreground = CatColors.Ui.Font.muted,
                border = Color.Transparent,
            )
        )
        return CatButtonState(
            normal = CatButtonStateStyle(
                colorStyle = CatButtonStateColorStyle(
                    background = p.bg,
                    foreground = p.fill,
                    border = Color.Transparent,
                )
            ),
            pressed = CatButtonStateStyle(
                colorStyle = CatButtonStateColorStyle(
                    background = p.bgActive,
                    foreground = p.fillActive,
                    border = Color.Transparent,
                )
            ),
            focused = CatButtonStateStyle(
                colorStyle = CatButtonStateColorStyle(
                    background = p.bg,
                    foreground = p.fill,
                    border = Color.Transparent,
                )
            ),
            disabled = disabledState,
        )
    }

    // MARK: Outlined — transparent background, colored border and text
    private fun outlinedConfig(p: CatColorPalette): CatButtonState {
        val disabledState = CatButtonStateStyle(
            colorStyle = CatButtonStateColorStyle(
                background = Color.Transparent,
                foreground = CatColors.Ui.Font.muted,
                border = CatColors.Ui.Font.muted
                    .copy(alpha = 0.20f),
            )
        )
        return CatButtonState(
            normal = CatButtonStateStyle(
                colorStyle = CatButtonStateColorStyle(
                    background = Color.Transparent,
                    foreground = p.text,
                    border = p.bg.copy(alpha = 0.20f),
                )
            ),
            pressed = CatButtonStateStyle(
                colorStyle = CatButtonStateColorStyle(
                    background = p.bgActive.copy(alpha = 0.15f),
                    foreground = p.text,
                    border = p.bg.copy(alpha = 0.20f),
                )
            ),
            focused = CatButtonStateStyle(
                colorStyle = CatButtonStateColorStyle(
                    background = Color.Transparent,
                    foreground = p.text,
                    border = p.bg.copy(alpha = 0.20f),
                )
            ),
            disabled = disabledState,
        )
    }

    // MARK: Text (ghost) — transparent background, no border, colored text
    private fun textConfig(p: CatColorPalette): CatButtonState {
        val disabledState = CatButtonStateStyle(
            colorStyle = CatButtonStateColorStyle(
                background = Color.Transparent,
                foreground = CatColors.Ui.Font.muted,
                border = Color.Transparent,
            )
        )
        return CatButtonState(
            normal = CatButtonStateStyle(
                colorStyle = CatButtonStateColorStyle(
                    background = Color.Transparent,
                    foreground = p.text,
                    border = Color.Transparent,
                )
            ),
            pressed = CatButtonStateStyle(
                colorStyle = CatButtonStateColorStyle(
                    background = p.bgActive.copy(alpha = 0.15f),
                    foreground = p.textActive,
                    border = Color.Transparent,
                )
            ),
            focused = CatButtonStateStyle(
                colorStyle = CatButtonStateColorStyle(
                    background = Color.Transparent,
                    foreground = p.text,
                    border = Color.Transparent,
                )
            ),
            disabled = disabledState,
        )
    }

    // MARK: Link — transparent, no border, always underlined
    // There is no hover on Android/mobile, so the underline is shown in all
    // interactive states to visually distinguish Link from the Text variant,
    // matching the Figma design intent.
    private fun linkConfig(p: CatColorPalette): CatButtonState {
        val disabledState = CatButtonStateStyle(
            colorStyle = CatButtonStateColorStyle(
                background = Color.Transparent,
                foreground = CatColors.Ui.Font.muted,
                border = Color.Transparent,
            ),
            isUnderlined = false,
        )
        return CatButtonState(
            normal = CatButtonStateStyle(
                colorStyle = CatButtonStateColorStyle(
                    background = Color.Transparent,
                    foreground = p.text,
                    border = Color.Transparent,
                ),
                isUnderlined = true,
            ),
            pressed = CatButtonStateStyle(
                colorStyle = CatButtonStateColorStyle(
                    background = Color.Transparent,
                    foreground = p.textActive,
                    border = Color.Transparent,
                ),
                isUnderlined = true,
            ),
            focused = CatButtonStateStyle(
                colorStyle = CatButtonStateColorStyle(
                    background = Color.Transparent,
                    foreground = p.text,
                    border = Color.Transparent,
                ),
                isUnderlined = true,
            ),
            disabled = disabledState,
        )
    }
}

// ---------------------------------------------------------------------------
// CatButtonColor → CatColorPalette resolution
// ---------------------------------------------------------------------------

internal fun CatButtonColor.palette(): CatColorPalette =
    when (this) {
        CatButtonColor.Primary -> CatColorPalette.Primary
        CatButtonColor.PrimaryInverted -> CatColorPalette.PrimaryInverted
        CatButtonColor.Secondary -> CatColorPalette.Secondary
        CatButtonColor.SecondaryInverted -> CatColorPalette.SecondaryInverted
        CatButtonColor.Danger -> CatColorPalette.Danger
        CatButtonColor.Success -> CatColorPalette.Success
        CatButtonColor.Warning -> CatColorPalette.Warning
        CatButtonColor.Info -> CatColorPalette.Info
    }
