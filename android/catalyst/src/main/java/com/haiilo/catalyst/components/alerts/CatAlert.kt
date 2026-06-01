package com.haiilo.catalyst.components.alerts

import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.painter.Painter
import androidx.compose.ui.text.style.TextOverflow
import com.haiilo.catalyst.components.buttons.CatButton
import com.haiilo.catalyst.components.buttons.CatButtonColor
import com.haiilo.catalyst.components.buttons.CatButtonContent
import com.haiilo.catalyst.components.buttons.CatButtonSize
import com.haiilo.catalyst.components.buttons.CatButtonVariant
import com.haiilo.catalyst.theme.LocalCatAccentPalette
import com.haiilo.catalyst.tokens.generated.CatBorderRadius
import com.haiilo.catalyst.tokens.generated.CatBorderWidth
import com.haiilo.catalyst.tokens.generated.CatSizes
import com.haiilo.catalyst.tokens.generated.CatSpacing
import com.haiilo.catalyst.tokens.generated.CatTypography

// ---------------------------------------------------------------------------
// CatAlert
//
// A card-like alert composable for the Catalyst Android design system.
// Displays a leading icon, a heading text, and an action button.
//
// Layout modes (CatAlertButtonPlacement):
//   Trailing → icon + heading + button all in one Row (short headings)
//   Below    → icon + column(heading + button) (multi-line headings)
//
// Configuration priority (highest → lowest):
//   1. Explicit [style]
//   2. Explicit [color]
//   3. [LocalCatAlertConfig] (ProvideCatAlertConfig)
//   4. Default: Info
// ---------------------------------------------------------------------------

/**
 * Catalyst alert component.
 *
 * @param heading              The heading text displayed in the alert.
 * @param leadingIcon          Painter for the icon shown at the start of the alert.
 * @param buttonText           Label for the action button.
 * @param onButtonClick        Called when the action button is tapped.
 * @param modifier             Modifier applied to the outer card container.
 * @param color                Semantic color role override. Null reads from [LocalCatAlertConfig].
 * @param buttonPlacement      Controls whether the action button is placed trailing
 *                             the heading ([CatAlertButtonPlacement.Trailing]) or
 *                             below it ([CatAlertButtonPlacement.Below]).
 *                             Use [CatAlertButtonPlacement.Below] when the heading
 *                             is long enough to wrap to multiple lines.
 * @param iconContentDescription  Accessibility description for the leading icon.
 *                             Pass null if the icon is purely decorative.
 * @param enabled              When false, the action button renders in the
 *                             disabled state and ignores taps.
 * @param style                Full color override. When non-null, [color] is ignored
 *                             for styling. This is an escape hatch for one-off
 *                             styling — avoid for standard design-system usage.
 */
@Composable
fun CatAlert(
    heading: String,
    leadingIcon: Painter,
    buttonText: String,
    onButtonClick: () -> Unit,
    modifier: Modifier = Modifier,
    color: CatAlertColor? = null,
    buttonPlacement: CatAlertButtonPlacement = CatAlertButtonPlacement.Trailing,
    iconContentDescription: String? = null,
    enabled: Boolean = true,
    style: CatAlertColors? = null,
) {
    // -----------------------------------------------------------------------
    // Resolve configuration
    // -----------------------------------------------------------------------
    val ambientConfig = LocalCatAlertConfig.current
    val resolvedColor = color ?: ambientConfig.color
    val accentPalette = LocalCatAccentPalette.current
    val resolvedColors = style ?: CatAlertDefaults.colors(resolvedColor, accentPalette)
    val shape = RoundedCornerShape(CatBorderRadius.border_radius_lg)

    // -----------------------------------------------------------------------
    // Card container: surface background + semantic border + content padding
    // -----------------------------------------------------------------------
    val containerModifier = modifier
        .fillMaxWidth()
        .clip(shape)
        .background(color = resolvedColors.background, shape = shape)
        .border(
            BorderStroke(CatBorderWidth.border_width_default, resolvedColors.border),
            shape,
        ).padding(CatSpacing.spacing_xl)

    // -----------------------------------------------------------------------
    // Shared sub-composables
    // -----------------------------------------------------------------------
    val leadingIconSlot: @Composable () -> Unit = {
        Icon(
            painter = leadingIcon,
            contentDescription = iconContentDescription,
            modifier = Modifier.size(CatSizes.size_md), // 20 dp — matches button icon size
            tint = resolvedColors.icon,
        )
    }

    val actionButton: @Composable () -> Unit = {
        CatButton(
            content = CatButtonContent.TextOnly(buttonText),
            onClick = onButtonClick,
            variant = CatButtonVariant.Outlined,
            color = CatButtonColor.Secondary,
            size = CatButtonSize.Small,
            enabled = enabled,
        )
    }

    // -----------------------------------------------------------------------
    // Layout — switches between Trailing and Below placements
    // -----------------------------------------------------------------------
    when (buttonPlacement) {
        // Icon ─ Heading (fills space) ─ Button
        CatAlertButtonPlacement.Trailing -> {
            Row(
                modifier = containerModifier,
                verticalAlignment = Alignment.CenterVertically,
                horizontalArrangement = Arrangement.spacedBy(CatSpacing.spacing_md),
            ) {
                leadingIconSlot()
                Text(
                    text = heading,
                    modifier = Modifier.weight(1f),
                    style = CatTypography.s1,
                    color = resolvedColors.text,
                    overflow = TextOverflow.Ellipsis,
                    maxLines = 1,
                )
                actionButton()
            }
        }

        // Icon ─ Column(Heading wrapping ↕ Button)
        CatAlertButtonPlacement.Below -> {
            Row(
                modifier = containerModifier,
                verticalAlignment = Alignment.Top,
                horizontalArrangement = Arrangement.spacedBy(CatSpacing.spacing_md),
            ) {
                leadingIconSlot()
                Column(
                    modifier = Modifier.weight(1f),
                    verticalArrangement = Arrangement.spacedBy(CatSpacing.spacing_md),
                ) {
                    Text(
                        text = heading,
                        style = CatTypography.s1,
                        color = resolvedColors.text,
                        overflow = TextOverflow.Ellipsis,
                        maxLines = Int.MAX_VALUE,
                    )
                    actionButton()
                }
            }
        }
    }
}
