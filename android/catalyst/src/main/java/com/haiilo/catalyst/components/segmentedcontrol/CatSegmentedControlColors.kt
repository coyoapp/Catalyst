package com.haiilo.catalyst.components.segmentedcontrol

import androidx.compose.ui.graphics.Color

// ---------------------------------------------------------------------------
// Resolved colors for a segmented control.
// ---------------------------------------------------------------------------

data class CatSegmentedControlSegmentColors(
    val background: Color,
    val foreground: Color,
)

data class CatSegmentedControlItemStateColors(
    val selected: CatSegmentedControlSegmentColors,
    val selectedPressed: CatSegmentedControlSegmentColors,
    val selectedDisabled: CatSegmentedControlSegmentColors,
    val unselected: CatSegmentedControlSegmentColors,
    val unselectedPressed: CatSegmentedControlSegmentColors,
    val unselectedDisabled: CatSegmentedControlSegmentColors,
)

/**
 * Resolved color values for a single [CatSegmentedControl] instance.
 *
 * Pass a fully constructed [CatSegmentedControlColors] to [CatSegmentedControl]'s
 * `style` parameter to bypass the default token resolution entirely.
 */
data class CatSegmentedControlColors(
    val containerBackground: Color,
    val containerBorder: Color,
    val itemColors: CatSegmentedControlItemStateColors,
)
