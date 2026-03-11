package com.haiilo.catalyst.components.buttons

import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.interaction.MutableInteractionSource
import androidx.compose.foundation.interaction.collectIsFocusedAsState
import androidx.compose.foundation.interaction.collectIsPressedAsState
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.defaultMinSize
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.material3.ripple
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.semantics.Role
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.style.TextDecoration
import androidx.compose.ui.unit.dp
import com.haiilo.catalyst.tokens.generated.CatBorderRadius
import com.haiilo.catalyst.tokens.generated.CatBorderWidth
import com.haiilo.catalyst.tokens.generated.CatSizes
import com.haiilo.catalyst.tokens.generated.CatSpacing
import com.haiilo.catalyst.tokens.generated.CatTypography

// ---------------------------------------------------------------------------
// CatButton
//
// The single public button composable for the Catalyst Android design system.
// Fully custom layout — does NOT use Material3 Button/OutlinedButton so we
// have complete control over exact height, padding, color, and text decoration.
//
// Configuration priority (highest → lowest):
//   1. Explicit [style]
//   2. Explicit [variant] / [color]
//   3. [LocalCatButtonConfig] (ProvideCatButtonConfig)
//   4. Defaults: Filled + Primary
// ---------------------------------------------------------------------------

/**
 * Catalyst button component.
 *
 * @param content     What the button displays — text, icon, or icon + text.
 * @param onClick     Called when the button is tapped.
 * @param modifier    Modifier applied to the outer container.
 * @param variant     Visual shape override. Null reads from [LocalCatButtonConfig].
 * @param color Semantic color role override. Null reads from [LocalCatButtonConfig].
 * @param size        Controls height and horizontal padding. Defaults to [CatButtonSize.Medium].
 * @param enabled     When false the button is shown in the disabled state and ignores taps.
 * @param style       Full state-style override. When non-null, [variant]/[color] are
 *                    ignored for styling.
 */
@Composable
fun CatButton(
    content: CatButtonContent,
    onClick: () -> Unit,
    modifier: Modifier = Modifier,
    variant: CatButtonVariant? = null,
    color: CatButtonColor? = null,
    size: CatButtonSize = CatButtonSize.Medium,
    enabled: Boolean = true,
    style: CatButtonState? = null,
) {
    // -----------------------------------------------------------------------
    // Resolve configuration
    // -----------------------------------------------------------------------
    val ambientConfig = LocalCatButtonConfig.current
    val resolvedVariant = variant ?: ambientConfig.variant
    val resolvedColor = color ?: ambientConfig.color

    val resolvedStyle = style
        ?: CatButtonDefaults.style(resolvedVariant, resolvedColor)

    // -----------------------------------------------------------------------
    // Interaction tracking
    // -----------------------------------------------------------------------
    val interactionSource = remember { MutableInteractionSource() }
    val isPressed by interactionSource.collectIsPressedAsState()
    val isFocused by interactionSource.collectIsFocusedAsState()

    // -----------------------------------------------------------------------
    // Per-state style
    // -----------------------------------------------------------------------
    val stateStyle = when {
        !enabled -> resolvedStyle.disabled
        isPressed -> resolvedStyle.pressed
        isFocused -> resolvedStyle.focused
        else -> resolvedStyle.normal
    }

    val backgroundColor = stateStyle.colorStyle.background
    val foregroundColor = stateStyle.colorStyle.foreground
    val borderColor = stateStyle.colorStyle.border
    val isUnderlined = stateStyle.isUnderlined

    // -----------------------------------------------------------------------
    // Typography
    //   Filled  → button1 (Lato SemiBold 16sp)
    //   Others  → button2 (Lato Regular 16sp)
    //   Link    → underline decoration when isUnderlined == true
    // -----------------------------------------------------------------------
    val baseTextStyle: TextStyle = when (resolvedVariant) {
        CatButtonVariant.Filled -> CatTypography.button1
        else -> CatTypography.button2
    }
    val textStyle = if (isUnderlined) {
        baseTextStyle.copy(textDecoration = TextDecoration.Underline)
    } else {
        baseTextStyle.copy(textDecoration = TextDecoration.None)
    }

    // -----------------------------------------------------------------------
    // Shape from design tokens
    //   cornerRadius → CatBorderRadius.border_radius_md = 8 dp
    //   borderWidth  → CatBorderWidth.border_width_thin = 2 dp (Outlined only)
    // -----------------------------------------------------------------------
    val shape = RoundedCornerShape(CatBorderRadius.border_radius_md)

    // -----------------------------------------------------------------------
    // Modifier chain:
    //   minWidth 44dp → exact height → clip → background
    //   → optional border (Outlined) → clickable with ripple
    //
    // We use a raw clickable instead of Material Button to own sizing fully.
    // -----------------------------------------------------------------------
    val containerModifier = modifier
        .defaultMinSize(minWidth = 44.dp)
        .height(size.heightDp)                         // exact height from token
        .clip(shape)
        .background(color = backgroundColor, shape = shape)
        .then(
            if (resolvedVariant == CatButtonVariant.Outlined) {
                Modifier.border(
                    BorderStroke(CatBorderWidth.border_width_thin, borderColor),
                    shape,
                )
            } else {
                Modifier
            }
        )
        .clickable(
            interactionSource = interactionSource,
            indication = ripple(color = foregroundColor.copy(alpha = 0.12f)),
            enabled = enabled,
            role = Role.Button,
            onClick = onClick,
        )

    // -----------------------------------------------------------------------
    // Layout: outer Box owns the size constraints; inner Box applies the
    // per-size horizontal padding.
    // -----------------------------------------------------------------------
    Box(
        modifier = containerModifier,
        contentAlignment = Alignment.Center,
    ) {
        Box(
            modifier = Modifier.padding(horizontal = size.horizontalPaddingDp),
            contentAlignment = Alignment.Center,
        ) {
            ButtonContentLayout(
                content = content,
                foregroundColor = foregroundColor,
                textStyle = textStyle,
            )
        }
    }
}

// ---------------------------------------------------------------------------
// ButtonContentLayout (internal)
//
// Icon size : CatSizes.size_lg = 24 dp
// Gap       : CatSpacing.spacing_xs = 4 dp  (Figma spacingXs variable)
// ---------------------------------------------------------------------------

@Composable
private fun ButtonContentLayout(
    content: CatButtonContent,
    foregroundColor: Color,
    textStyle: TextStyle,
) {
    when (content) {

        is CatButtonContent.TextOnly -> {
            Text(
                text = content.text,
                style = textStyle,
                color = foregroundColor,
            )
        }

        is CatButtonContent.IconOnly -> {
            Icon(
                painter = content.painter,
                contentDescription = content.contentDescription,
                modifier = Modifier.size(CatSizes.size_lg),  // 24 dp
                tint = foregroundColor,
            )
        }

        is CatButtonContent.IconText -> {
            Row(
                verticalAlignment = Alignment.CenterVertically,
                horizontalArrangement = Arrangement.Center,
            ) {
                val icon: @Composable () -> Unit = {
                    Icon(
                        painter = content.painter,
                        contentDescription = content.iconContentDescription,
                        modifier = Modifier.size(CatSizes.size_lg),  // 24 dp
                        tint = foregroundColor,
                    )
                }
                val label: @Composable () -> Unit = {
                    Text(
                        text = content.text,
                        style = textStyle,
                        color = foregroundColor,
                    )
                }

                when (content.placement) {
                    CatButtonPlacement.Leading -> {
                        icon()
                        Spacer(Modifier.width(CatSpacing.spacing_xs))  // 4 dp — Figma spacingXs
                        label()
                    }

                    CatButtonPlacement.Trailing -> {
                        label()
                        Spacer(Modifier.width(CatSpacing.spacing_xs))  // 4 dp
                        icon()
                    }
                }
            }
        }
    }
}
