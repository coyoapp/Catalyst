package com.haiilo.catalyst.components.buttons

import androidx.compose.ui.graphics.Color
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
// CatColorPalette
//
// Holds the resolved color slots for a single color.
// ---------------------------------------------------------------------------

internal data class CatColorPalette(
    val bg: Color,
    val bgHover: Color,
    val bgActive: Color,
    val fill: Color,
    val fillHover: Color,
    val fillActive: Color,
    val text: Color,
    val textHover: Color,
    val textActive: Color,
)

// ---------------------------------------------------------------------------
// CatButtonColor → CatColorPalette resolution
// Maps each color to its corresponding CatColors.Theme.* token object.
// ---------------------------------------------------------------------------

internal fun CatButtonColor.palette(): CatColorPalette =
    when (this) {
        CatButtonColor.Primary -> CatColorPalette(
            bg = CatColors.Theme.Primary.bg,
            bgHover = CatColors.Theme.Primary.bgHover,
            bgActive = CatColors.Theme.Primary.bgActive,
            fill = CatColors.Theme.Primary.fill,
            fillHover = CatColors.Theme.Primary.fillHover,
            fillActive = CatColors.Theme.Primary.fillActive,
            text = CatColors.Theme.Primary.text,
            textHover = CatColors.Theme.Primary.textHover,
            textActive = CatColors.Theme.Primary.textActive,
        )
        CatButtonColor.PrimaryInverted -> CatColorPalette(
            bg = CatColors.Theme.PrimaryInverted.bg,
            bgHover = CatColors.Theme.PrimaryInverted.bgHover,
            bgActive = CatColors.Theme.PrimaryInverted.bgActive,
            fill = CatColors.Theme.PrimaryInverted.fill,
            fillHover = CatColors.Theme.PrimaryInverted.fillHover,
            fillActive = CatColors.Theme.PrimaryInverted.fillActive,
            text = CatColors.Theme.PrimaryInverted.text,
            textHover = CatColors.Theme.PrimaryInverted.textHover,
            textActive = CatColors.Theme.PrimaryInverted.textActive,
        )
        CatButtonColor.Secondary -> CatColorPalette(
            bg = CatColors.Theme.Secondary.bg,
            bgHover = CatColors.Theme.Secondary.bgHover,
            bgActive = CatColors.Theme.Secondary.bgActive,
            fill = CatColors.Theme.Secondary.fill,
            fillHover = CatColors.Theme.Secondary.fillHover,
            fillActive = CatColors.Theme.Secondary.fillActive,
            text = CatColors.Theme.Secondary.text,
            textHover = CatColors.Theme.Secondary.textHover,
            textActive = CatColors.Theme.Secondary.textActive,
        )
        CatButtonColor.SecondaryInverted -> CatColorPalette(
            bg = CatColors.Theme.SecondaryInverted.bg,
            bgHover = CatColors.Theme.SecondaryInverted.bgHover,
            bgActive = CatColors.Theme.SecondaryInverted.bgActive,
            fill = CatColors.Theme.SecondaryInverted.fill,
            fillHover = CatColors.Theme.SecondaryInverted.fillHover,
            fillActive = CatColors.Theme.SecondaryInverted.fillActive,
            text = CatColors.Theme.SecondaryInverted.text,
            textHover = CatColors.Theme.SecondaryInverted.textHover,
            textActive = CatColors.Theme.SecondaryInverted.textActive,
        )
        CatButtonColor.Danger -> CatColorPalette(
            bg = CatColors.Theme.Danger.bg,
            bgHover = CatColors.Theme.Danger.bgHover,
            bgActive = CatColors.Theme.Danger.bgActive,
            fill = CatColors.Theme.Danger.fill,
            fillHover = CatColors.Theme.Danger.fillHover,
            fillActive = CatColors.Theme.Danger.fillActive,
            text = CatColors.Theme.Danger.text,
            textHover = CatColors.Theme.Danger.textHover,
            textActive = CatColors.Theme.Danger.textActive,
        )
        CatButtonColor.Success -> CatColorPalette(
            bg = CatColors.Theme.Success.bg,
            bgHover = CatColors.Theme.Success.bgHover,
            bgActive = CatColors.Theme.Success.bgActive,
            fill = CatColors.Theme.Success.fill,
            fillHover = CatColors.Theme.Success.fillHover,
            fillActive = CatColors.Theme.Success.fillActive,
            text = CatColors.Theme.Success.text,
            textHover = CatColors.Theme.Success.textHover,
            textActive = CatColors.Theme.Success.textActive,
        )
        CatButtonColor.Warning -> CatColorPalette(
            bg = CatColors.Theme.Warning.bg,
            bgHover = CatColors.Theme.Warning.bgHover,
            bgActive = CatColors.Theme.Warning.bgActive,
            fill = CatColors.Theme.Warning.fill,
            fillHover = CatColors.Theme.Warning.fillHover,
            fillActive = CatColors.Theme.Warning.fillActive,
            text = CatColors.Theme.Warning.text,
            textHover = CatColors.Theme.Warning.textHover,
            textActive = CatColors.Theme.Warning.textActive,
        )
        CatButtonColor.Info -> CatColorPalette(
            bg = CatColors.Theme.Info.bg,
            bgHover = CatColors.Theme.Info.bgHover,
            bgActive = CatColors.Theme.Info.bgActive,
            fill = CatColors.Theme.Info.fill,
            fillHover = CatColors.Theme.Info.fillHover,
            fillActive = CatColors.Theme.Info.fillActive,
            text = CatColors.Theme.Info.text,
            textHover = CatColors.Theme.Info.textHover,
            textActive = CatColors.Theme.Info.textActive,
        )
    }
