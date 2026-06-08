package com.haiilo.catalyst.components.alerts

import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.background
import androidx.compose.foundation.border
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
import androidx.compose.ui.layout.SubcomposeLayout
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.AnnotatedString
import androidx.compose.ui.text.rememberTextMeasurer
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.Constraints
import com.haiilo.catalyst.theme.LocalCatAccentPalette
import com.haiilo.catalyst.tokens.generated.CatBorderRadius
import com.haiilo.catalyst.tokens.generated.CatBorderWidth
import com.haiilo.catalyst.tokens.generated.CatSizes
import com.haiilo.catalyst.tokens.generated.CatSpacing
import com.haiilo.catalyst.tokens.generated.CatTypography

// ---------------------------------------------------------------------------
// CatAlert
//
// Inline alert card with:
//   - a leading icon,
//   - a heading,
//   - an optional action slot.
//
// Layout strategy:
//   - [CatAlertButtonPlacement.Automatic]: keeps action trailing when heading fits
//     on a single line; otherwise places action below the heading.
//   - [CatAlertButtonPlacement.Trailing]: always keeps action inline.
//   - [CatAlertButtonPlacement.Below]: always stacks action below heading.
//
// Color/style configuration priority (highest -> lowest):
//   1. Explicit [style]
//   2. Explicit [color]
//   3. [LocalCatAlertConfig] (ProvideCatAlertConfig)
//   4. Defaults from [CatAlertDefaults]
// ---------------------------------------------------------------------------

private enum class CatAlertLayoutSlot {
    Icon,
    HeadingTrailing,
    HeadingBelow,
    Action,
}

/**
 * Catalyst alert component.
 *
 * Displays a rounded alert container with semantic colors, a leading icon, heading text,
 * and an optional action composable.
 *
 * Automatic placement behavior is close to SwiftUI `ViewThatFits`: if heading + action can
 * fit on one line, action is rendered trailing; otherwise action is moved below heading.
 *
 * Accessibility note: this composable does not collapse content into one custom label. The
 * heading text and action keep their own semantics so screen readers can focus them separately.
 *
 * @param modifier Modifier applied to the alert container.
 * @param heading Main alert message.
 * @param leadingIcon Icon shown on the leading side of the alert.
 * @param color Semantic alert color override. Null reads from [LocalCatAlertConfig].
 * @param buttonPlacement Placement policy for [action]. Defaults to [CatAlertButtonPlacement.Automatic].
 * @param iconContentDescription Accessibility description for [leadingIcon].
 * @param style Full color-style override. When non-null, [color] is ignored for styling.
 * @param action Optional action slot, typically a [com.haiilo.catalyst.components.buttons.CatButton].
 */
@Composable
fun CatAlert(
    modifier: Modifier = Modifier,
    heading: String,
    leadingIcon: Painter = painterResource(id = com.haiilo.catalyst.R.drawable.info_circle_outlined),
    color: CatAlertColor? = null,
    buttonPlacement: CatAlertButtonPlacement = CatAlertButtonPlacement.Automatic,
    iconContentDescription: String? = null,
    style: CatAlertColors? = null,
    action: (@Composable () -> Unit)? = null,
) {
    // -----------------------------------------------------------------------
    // Resolve style from explicit overrides and ambient configuration.
    // -----------------------------------------------------------------------
    val ambientConfig = LocalCatAlertConfig.current
    val resolvedColor = color ?: ambientConfig.color
    val accentPalette = LocalCatAccentPalette.current
    val resolvedColors = style ?: CatAlertDefaults.colors(resolvedColor, accentPalette)
    val shape = RoundedCornerShape(CatBorderRadius.border_radius_lg)

    val containerModifier = modifier
        .clip(shape)
        .background(color = resolvedColors.background, shape = shape)
        .border(
            BorderStroke(CatBorderWidth.border_width_default, resolvedColors.border),
            shape,
        ).padding(CatSpacing.spacing_xl)

    // -----------------------------------------------------------------------
    // Measure heading text for Automatic placement decisions.
    // -----------------------------------------------------------------------
    val textMeasurer = rememberTextMeasurer()

    SubcomposeLayout(modifier = containerModifier) { constraints ->
        // -------------------------------------------------------------------
        // First pass: measure icon and optional action.
        // -------------------------------------------------------------------
        val iconPlaceable = subcompose(CatAlertLayoutSlot.Icon) {
            Icon(
                painter = leadingIcon,
                contentDescription = iconContentDescription,
                modifier = Modifier.size(CatSizes.size_md),
                tint = resolvedColors.icon,
            )
        }.first().measure(constraints.copy(minWidth = 0, minHeight = 0))

        val actionPlaceables = action
            ?.let {
                subcompose(CatAlertLayoutSlot.Action) { it() }
                    .map { measurable ->
                        measurable.measure(
                            constraints.copy(
                                minWidth = 0,
                                minHeight = 0,
                                maxWidth = Constraints.Infinity
                            ),
                        )
                    }
            }.orEmpty()
        val actionPlaceable = actionPlaceables.firstOrNull()
        val actionWidth = actionPlaceable?.width ?: 0

        val spacingPx = CatSpacing.spacing_md.roundToPx()
        val hasAction = actionPlaceable != null

        val trailingHeadingMaxWidth = if (hasAction) {
            (constraints.maxWidth - iconPlaceable.width - spacingPx - actionWidth - spacingPx)
                .coerceAtLeast(0)
        } else {
            (constraints.maxWidth - iconPlaceable.width - spacingPx).coerceAtLeast(0)
        }

        // In automatic mode, choose trailing only if single-line heading fits
        // next to icon and action without visual overflow.
        val autoUseTrailing = if (!hasAction) {
            false
        } else if (trailingHeadingMaxWidth <= 0) {
            false
        } else {
            val headingLayout = textMeasurer.measure(
                text = AnnotatedString(heading),
                style = CatTypography.s1,
                overflow = TextOverflow.Ellipsis,
                maxLines = 1,
                constraints = Constraints(maxWidth = trailingHeadingMaxWidth),
            )
            !headingLayout.hasVisualOverflow
        }

        val useTrailing = when (buttonPlacement) {
            CatAlertButtonPlacement.Trailing -> true
            CatAlertButtonPlacement.Below -> false
            CatAlertButtonPlacement.Automatic -> autoUseTrailing
        }

        if (useTrailing) {
            // Inline layout: icon + single-line heading + trailing action.
            val headingPlaceable = subcompose(CatAlertLayoutSlot.HeadingTrailing) {
                Text(
                    text = heading,
                    style = CatTypography.s1,
                    color = resolvedColors.text,
                    overflow = TextOverflow.Ellipsis,
                    maxLines = 1,
                )
            }.first().measure(
                constraints.copy(
                    minWidth = 0,
                    minHeight = 0,
                    maxWidth = trailingHeadingMaxWidth,
                ),
            )

            val height = maxOf(
                iconPlaceable.height,
                headingPlaceable.height,
                actionPlaceable?.height ?: 0,
            )

            layout(width = constraints.maxWidth, height = height) {
                val iconY = Alignment.CenterVertically.align(iconPlaceable.height, height)
                iconPlaceable.placeRelative(x = 0, y = iconY)

                val headingX = iconPlaceable.width + spacingPx
                val headingY = Alignment.CenterVertically.align(headingPlaceable.height, height)
                headingPlaceable.placeRelative(x = headingX, y = headingY)

                actionPlaceable?.let {
                    val actionX = constraints.maxWidth - it.width
                    val actionY = Alignment.CenterVertically.align(it.height, height)
                    it.placeRelative(x = actionX, y = actionY)
                }
            }
        } else {
            // Stacked layout: icon column + heading and optional action below.
            val belowHeadingMaxWidth =
                (constraints.maxWidth - iconPlaceable.width - spacingPx).coerceAtLeast(0)

            val headingPlaceable = subcompose(CatAlertLayoutSlot.HeadingBelow) {
                Text(
                    text = heading,
                    style = CatTypography.s1,
                    color = resolvedColors.text,
                    overflow = TextOverflow.Ellipsis,
                    maxLines = Int.MAX_VALUE,
                )
            }.first().measure(
                constraints.copy(
                    minWidth = 0,
                    minHeight = 0,
                    maxWidth = belowHeadingMaxWidth,
                ),
            )

            val columnHeight = headingPlaceable.height + if (hasAction) {
                spacingPx + actionPlaceable.height
            } else {
                0
            }
            val height = maxOf(iconPlaceable.height, columnHeight)

            layout(width = constraints.maxWidth, height = height) {
                iconPlaceable.placeRelative(x = 0, y = 0)

                val columnX = iconPlaceable.width + spacingPx
                headingPlaceable.placeRelative(x = columnX, y = 0)

                actionPlaceable?.placeRelative(x = columnX, y = headingPlaceable.height + spacingPx)
            }
        }
    }
}
