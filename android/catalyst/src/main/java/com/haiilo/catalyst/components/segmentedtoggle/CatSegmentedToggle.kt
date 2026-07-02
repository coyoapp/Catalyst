package com.haiilo.catalyst.components.segmentedtoggle

import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.interaction.MutableInteractionSource
import androidx.compose.foundation.interaction.collectIsPressedAsState
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.defaultMinSize
import androidx.compose.foundation.layout.fillMaxHeight
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.layout.wrapContentWidth
import androidx.compose.foundation.selection.selectable
import androidx.compose.foundation.selection.selectableGroup
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.material3.ripple
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.key
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.semantics.Role
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import com.haiilo.catalyst.theme.LocalCatAccentPalette
import com.haiilo.catalyst.tokens.generated.CatBorderRadius
import com.haiilo.catalyst.tokens.generated.CatBorderWidth
import com.haiilo.catalyst.tokens.generated.CatSizes
import com.haiilo.catalyst.tokens.generated.CatSpacing
import com.haiilo.catalyst.tokens.generated.CatTypography

// ---------------------------------------------------------------------------
// CatSegmentedToggle
//
// Single-select segmented toggle for Catalyst Android.
//
// Configuration priority (highest -> lowest):
//   1. Explicit [style]
//   2. Explicit [color]
//   3. Defaults: Primary
// ---------------------------------------------------------------------------

/**
 * Convenience overload for the common two-option segmented toggle.
 *
 * Prefer this overload for the standard v1 binary-toggle use case. The generic
 * `items = listOf(...)` overload remains available for more advanced layouts.
 */
@Composable
fun <T> CatSegmentedToggle(
    firstItem: CatSegmentedToggleItem<T>,
    secondItem: CatSegmentedToggleItem<T>,
    selectedValue: T?,
    onSelectionChange: (T) -> Unit,
    modifier: Modifier = Modifier,
    color: CatSegmentedToggleColor = CatSegmentedToggleColor.Primary,
    size: CatSegmentedToggleSize = CatSegmentedToggleSize.Medium,
    enabled: Boolean = true,
    style: CatSegmentedToggleColors? = null,
) {
    CatSegmentedToggle(
        items = listOf(firstItem, secondItem),
        selectedValue = selectedValue,
        onSelectionChange = onSelectionChange,
        modifier = modifier,
        color = color,
        size = size,
        enabled = enabled,
        equalWidth = true,
        style = style,
    )
}

/**
 * Catalyst segmented toggle component.
 *
 * @param items              Segments rendered in order from start to end.
 * @param selectedValue      Currently selected value. Pass null for an initially
 *                           unselected state.
 * @param onSelectionChange  Called when the user chooses a different segment.
 * @param modifier           Modifier applied to the outer container.
 * @param color              Semantic color role used by the selected segment.
 * @param size               Controls overall height and segment padding.
 * @param enabled            Parent enabled state for the whole control.
 * @param equalWidth         When true, segments share the same width. In bounded
 *                           layouts such as `Modifier.fillMaxWidth()`, the
 *                           available width is divided evenly across segments.
 * @param style              Full color override. When non-null, [color] is
 *                           ignored for styling.
 */
@Composable
fun <T> CatSegmentedToggle(
    items: List<CatSegmentedToggleItem<T>>,
    selectedValue: T?,
    onSelectionChange: (T) -> Unit,
    modifier: Modifier = Modifier,
    color: CatSegmentedToggleColor = CatSegmentedToggleColor.Primary,
    size: CatSegmentedToggleSize = CatSegmentedToggleSize.Medium,
    enabled: Boolean = true,
    equalWidth: Boolean = true,
    style: CatSegmentedToggleColors? = null,
) {
    require(items.isNotEmpty()) { "CatSegmentedToggle requires at least one item." }
    require(items.map { it.value }.distinct().size == items.size) {
        "CatSegmentedToggle items must have distinct values."
    }

    val accentPalette = LocalCatAccentPalette.current
    val resolvedColors = style ?: CatSegmentedToggleDefaults.colors(color, accentPalette)
    val outerShape = RoundedCornerShape(CatBorderRadius.border_radius_lg)
    val innerShape = RoundedCornerShape(CatBorderRadius.border_radius_md)

    Box(
        modifier = modifier
            .height(size.heightDp)
            .clip(outerShape)
            .background(resolvedColors.containerBackground, outerShape)
            .border(
                border = BorderStroke(CatBorderWidth.border_width_default, resolvedColors.containerBorder),
                shape = outerShape,
            ).padding(CatSpacing.spacing_xs)
            .selectableGroup(),
        contentAlignment = Alignment.Center,
    ) {
        Row(
            modifier = if (equalWidth) {
                Modifier.fillMaxSize()
            } else {
                Modifier
                    .fillMaxHeight()
                    .wrapContentWidth()
            },
            horizontalArrangement = Arrangement.spacedBy(CatSpacing.spacing_xs),
            verticalAlignment = Alignment.CenterVertically,
        ) {
            items.forEach { item ->
                key(item.value) {
                    CatSegmentedToggleSegment(
                        modifier = if (equalWidth) {
                            Modifier
                                .weight(1f)
                                .fillMaxHeight()
                        } else {
                            Modifier.fillMaxHeight()
                        },
                        item = item,
                        isSelected = item.value == selectedValue,
                        size = size,
                        enabled = enabled,
                        colors = resolvedColors,
                        shape = innerShape,
                        onSelectionChange = onSelectionChange,
                    )
                }
            }
        }
    }
}

@Composable
private fun <T> CatSegmentedToggleSegment(
    modifier: Modifier,
    item: CatSegmentedToggleItem<T>,
    isSelected: Boolean,
    size: CatSegmentedToggleSize,
    enabled: Boolean,
    colors: CatSegmentedToggleColors,
    shape: RoundedCornerShape,
    onSelectionChange: (T) -> Unit,
) {
    val interactionSource = remember { MutableInteractionSource() }
    val isPressed by interactionSource.collectIsPressedAsState()
    val itemEnabled = enabled && item.enabled

    val resolvedItemColors = when {
        !itemEnabled && isSelected -> colors.itemColors.selectedDisabled
        !itemEnabled -> colors.itemColors.unselectedDisabled
        isPressed && isSelected -> colors.itemColors.selectedPressed
        isPressed -> colors.itemColors.unselectedPressed
        isSelected -> colors.itemColors.selected
        else -> colors.itemColors.unselected
    }
    val textStyle = if (isSelected) {
        CatTypography.button1
    } else {
        CatTypography.button2
    }

    Box(
        modifier = modifier
            .defaultMinSize(minWidth = 44.dp)
            .clip(shape)
            .background(resolvedItemColors.background, shape)
            .semantics(mergeDescendants = true) {}
            .selectable(
                selected = isSelected,
                enabled = itemEnabled,
                interactionSource = interactionSource,
                indication = ripple(color = resolvedItemColors.foreground.copy(alpha = 0.12f)),
                role = Role.RadioButton,
                onClick = {
                    if (!isSelected) {
                        onSelectionChange(item.value)
                    }
                },
            ).padding(horizontal = size.horizontalPaddingDp),
        contentAlignment = Alignment.Center,
    ) {
        CatSegmentedToggleContentLayout(
            content = item.content,
            foregroundColor = resolvedItemColors.foreground,
            textStyle = textStyle,
        )
    }
}

@Composable
private fun CatSegmentedToggleContentLayout(
    content: CatSegmentedToggleContent,
    foregroundColor: Color,
    textStyle: TextStyle,
) {
    when (content) {
        is CatSegmentedToggleContent.TextOnly -> {
            Text(
                text = content.text,
                style = textStyle,
                color = foregroundColor,
                maxLines = 1,
                overflow = TextOverflow.Ellipsis,
            )
        }

        is CatSegmentedToggleContent.IconOnly -> {
            Icon(
                painter = content.painter,
                contentDescription = content.contentDescription,
                modifier = Modifier.size(CatSizes.size_md),
                tint = foregroundColor,
            )
        }

        is CatSegmentedToggleContent.IconText -> {
            androidx.compose.foundation.layout.Row(
                verticalAlignment = Alignment.CenterVertically,
                horizontalArrangement = Arrangement.Center,
            ) {
                val icon: @Composable () -> Unit = {
                    Icon(
                        painter = content.painter,
                        contentDescription = content.iconContentDescription,
                        modifier = Modifier.size(CatSizes.size_md),
                        tint = foregroundColor,
                    )
                }
                val label: @Composable () -> Unit = {
                    Text(
                        text = content.text,
                        style = textStyle,
                        color = foregroundColor,
                        maxLines = 1,
                        overflow = TextOverflow.Ellipsis,
                    )
                }

                when (content.placement) {
                    CatSegmentedTogglePlacement.Leading -> {
                        icon()
                        Spacer(Modifier.width(CatSpacing.spacing_xs))
                        label()
                    }

                    CatSegmentedTogglePlacement.Trailing -> {
                        label()
                        Spacer(Modifier.width(CatSpacing.spacing_xs))
                        icon()
                    }
                }
            }
        }
    }
}
