package com.haiilo.catalyst.components.segmentedtoggle

import androidx.compose.ui.graphics.Color

// ---------------------------------------------------------------------------
// Resolved colors for a segmented toggle.
// ---------------------------------------------------------------------------

data class CatSegmentedToggleSegmentColors(
    val background: Color,
    val foreground: Color,
)

data class CatSegmentedToggleItemStateColors(
    val selected: CatSegmentedToggleSegmentColors,
    val selectedPressed: CatSegmentedToggleSegmentColors,
    val selectedDisabled: CatSegmentedToggleSegmentColors,
    val unselected: CatSegmentedToggleSegmentColors,
    val unselectedPressed: CatSegmentedToggleSegmentColors,
    val unselectedDisabled: CatSegmentedToggleSegmentColors,
)

/**
 * Resolved color values for a single [CatSegmentedToggle] instance.
 *
 * Pass a fully constructed [CatSegmentedToggleColors] to [CatSegmentedToggle]'s
 * `style` parameter to bypass the default token resolution entirely.
 */
data class CatSegmentedToggleColors(
    val containerBackground: Color,
    val containerBorder: Color,
    val itemColors: CatSegmentedToggleItemStateColors,
)
