package com.haiilo.catalyst.components.segmentedcontrol

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
import androidx.compose.ui.draw.alpha
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
// CatSegmentedControl
// ---------------------------------------------------------------------------

/**
 * Text-only convenience overload that uses the older segment-state rendering.
 */
@Composable
fun CatSegmentedControl(
    segments: List<String>,
    selection: Int,
    onSelectionChange: (Int) -> Unit,
    modifier: Modifier = Modifier,
    color: CatSegmentedControlColor = CatSegmentedControlColor.Primary,
    size: CatSegmentedControlSize = CatSegmentedControlSize.Medium,
    enabled: Boolean = true,
    style: CatSegmentedControlColors? = null,
) {
    require(segments.isNotEmpty()) { "CatSegmentedControl requires at least one segment." }

    val items = segments.mapIndexed { index, title ->
        CatSegmentedControlItem(
            value = index,
            content = CatSegmentedControlContent.TextOnly(title),
        )
    }

    CatSegmentedControl(
        items = items,
        selectedValue = selection.takeIf { it in segments.indices },
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
 * Restored state-driven segmented control implementation.
 */
@Composable
fun <T> CatSegmentedControl(
    items: List<CatSegmentedControlItem<T>>,
    selectedValue: T?,
    onSelectionChange: (T) -> Unit,
    modifier: Modifier = Modifier,
    color: CatSegmentedControlColor = CatSegmentedControlColor.Primary,
    size: CatSegmentedControlSize = CatSegmentedControlSize.Medium,
    enabled: Boolean = true,
    equalWidth: Boolean = true,
    style: CatSegmentedControlColors? = null,
) {
    require(items.isNotEmpty()) { "CatSegmentedControl requires at least one item." }
    require(items.map { it.value }.distinct().size == items.size) {
        "CatSegmentedControl items must have distinct values."
    }

    val accentPalette = LocalCatAccentPalette.current
    val resolvedColors = style ?: CatSegmentedControlDefaults.colors(color, accentPalette)
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
            )
            .padding(CatSpacing.spacing_xs)
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
                    CatSegmentedControlSegment(
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
private fun <T> CatSegmentedControlSegment(
    modifier: Modifier,
    item: CatSegmentedControlItem<T>,
    isSelected: Boolean,
    size: CatSegmentedControlSize,
    enabled: Boolean,
    colors: CatSegmentedControlColors,
    shape: RoundedCornerShape,
    onSelectionChange: (T) -> Unit,
) {
    val interactionSource = remember { MutableInteractionSource() }
    val isPressed by interactionSource.collectIsPressedAsState()
    val itemEnabled = enabled && item.enabled

    val resolvedItemColors = when {
        !itemEnabled -> colors.itemColors.disabled
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
            )
            .semantics(mergeDescendants = true) {}
            .alpha(if (itemEnabled) 1f else 0.5f)
            .padding(horizontal = size.horizontalPaddingDp),
        contentAlignment = Alignment.Center,
    ) {
        CatSegmentedControlContentLayout(
            content = item.content,
            foregroundColor = resolvedItemColors.foreground,
            textStyle = textStyle,
        )
    }
}

@Composable
private fun CatSegmentedControlContentLayout(
    content: CatSegmentedControlContent,
    foregroundColor: Color,
    textStyle: TextStyle,
) {
    when (content) {
        is CatSegmentedControlContent.TextOnly -> {
            Text(
                text = content.text,
                style = textStyle,
                color = foregroundColor,
                maxLines = 1,
                overflow = TextOverflow.Ellipsis,
            )
        }

        is CatSegmentedControlContent.IconOnly -> {
            Icon(
                painter = content.painter,
                contentDescription = content.contentDescription,
                modifier = Modifier.size(CatSizes.size_md),
                tint = foregroundColor,
            )
        }

        is CatSegmentedControlContent.IconText -> {
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
                    CatSegmentedControlPlacement.Leading -> {
                        icon()
                        Spacer(Modifier.width(CatSpacing.spacing_xs))
                        label()
                    }

                    CatSegmentedControlPlacement.Trailing -> {
                        label()
                        Spacer(Modifier.width(CatSpacing.spacing_xs))
                        icon()
                    }
                }
            }
        }
    }
}


