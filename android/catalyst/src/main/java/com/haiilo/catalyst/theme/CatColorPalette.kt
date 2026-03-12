package com.haiilo.catalyst.theme

import androidx.compose.ui.graphics.Color
import com.haiilo.catalyst.extensions.darken
import com.haiilo.catalyst.tokens.generated.CatColors

// ---------------------------------------------------------------------------
// CatColorPalette
//
// A resolved bag of the 9 semantic color slots exposed by every
// CatColors.Theme.* token group. Components read palette.bg, palette.text,
// etc. without coupling themselves to a specific token object or color role.
//
// Usage:
//
//   val p = CatColorPalette.Primary
//   val p = CatColorPalette.Danger
//
// or build a fully custom palette for whitelabeling:
//
//   val p = CatColorPalette(bg = myColor, ...)
// ---------------------------------------------------------------------------

data class CatColorPalette(
    val bg: Color,
    val bgHover: Color,
    val bgActive: Color,
    val fill: Color,
    val fillHover: Color,
    val fillActive: Color,
    val text: Color,
    val textHover: Color,
    val textActive: Color,
) {
    companion object {
        // -------------------------------------------------------------------
        // Accent color support
        // -------------------------------------------------------------------

        /**
         * Lightness-reduction factors applied to the accent base color to
         * produce hover and pressed variants.
         *
         * Mirrors `CatTheme.AccentColorDarkenFactor` on iOS.
         */
        object AccentDarkenFactor {
            const val HOVERED = 0.05f
            const val PRESSED = 0.11f
        }

        /**
         * Builds a [CatColorPalette] driven by a single brand accent [color].
         *
         * The hover and active shades are derived by darkening the base color
         * using HSL lightness reduction — matching the iOS implementation.
         *
         * Only the `bg*`, `fill*`, and `text*` slots relevant to the
         * [CatButtonVariant.Filled] / Outlined / Text / Link variants are
         * populated here; white is used for the foreground fill so the accent
         * background always has legible contrast.
         *
         * Mirrors `CatColorPalette(accentColor:)` on iOS.
         */
        fun fromAccentColor(color: Color): CatColorPalette {
            val bgHover = color.darken(AccentDarkenFactor.HOVERED)
            val bgActive = color.darken(AccentDarkenFactor.PRESSED)
            return CatColorPalette(
                bg = color,
                bgHover = bgHover,
                bgActive = bgActive,
                fill = Color.White,
                fillHover = Color.White,
                fillActive = Color.White,
                text = color,
                textHover = bgHover,
                textActive = bgActive,
            )
        }

        val Primary: CatColorPalette
            get() = CatColorPalette(
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

        val PrimaryInverted: CatColorPalette
            get() = CatColorPalette(
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

        val Secondary: CatColorPalette
            get() = CatColorPalette(
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

        val SecondaryInverted: CatColorPalette
            get() = CatColorPalette(
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

        val Danger: CatColorPalette
            get() = CatColorPalette(
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

        val Success: CatColorPalette
            get() = CatColorPalette(
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

        val Warning: CatColorPalette
            get() = CatColorPalette(
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

        val Info: CatColorPalette
            get() = CatColorPalette(
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
}
