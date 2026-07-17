package com.haiilo.catalyst.components.segmentedcontrol

import androidx.compose.ui.graphics.painter.Painter
import androidx.compose.ui.unit.Dp
import com.haiilo.catalyst.tokens.generated.CatSpacing

// ---------------------------------------------------------------------------
// CatSegmentedControlColor — semantic color role for the selected segment
// ---------------------------------------------------------------------------

enum class CatSegmentedControlColor {
    Primary,
    PrimaryInverted,
    Secondary,
    SecondaryInverted,
    Danger,
    Success,
    Warning,
    Info,
}

// ---------------------------------------------------------------------------
// Size — controls the overall control height and segment padding.
// Mirrors the button sizes so segmented controls align cleanly with CatButton.
// ---------------------------------------------------------------------------

sealed class CatSegmentedControlSize {
    /** 32 dp tall, 8 dp horizontal padding. */
    data object XSmall : CatSegmentedControlSize()

    /** 40 dp tall, 16 dp horizontal padding. */
    data object Small : CatSegmentedControlSize()

    /** 48 dp tall, 16 dp horizontal padding (default). */
    data object Medium : CatSegmentedControlSize()

    /** Arbitrary height; caller supplies horizontal padding via [horizontalPadding]. */
    data class Custom(
        val height: Dp,
        val horizontalPadding: Dp = CatSpacing.spacing_xl,
    ) : CatSegmentedControlSize()

    /** Total control height from design tokens. */
    val heightDp: Dp
        get() = when (this) {
            is XSmall -> CatSpacing.spacing_4xl
            is Small -> CatSpacing.spacing_5xl
            is Medium -> CatSpacing.spacing_6xl
            is Custom -> height
        }

    /** Horizontal padding for each segment. */
    val horizontalPaddingDp: Dp
        get() = when (this) {
            is XSmall -> CatSpacing.spacing_md
            is Small -> CatSpacing.spacing_xl
            is Medium -> CatSpacing.spacing_xl
            is Custom -> horizontalPadding
        }
}

// ---------------------------------------------------------------------------
// Placement — icon position relative to text inside a segment
// ---------------------------------------------------------------------------

enum class CatSegmentedControlPlacement {
    Leading,
    Trailing,
}

// ---------------------------------------------------------------------------
// Content — what an individual segment displays
// ---------------------------------------------------------------------------

sealed class CatSegmentedControlContent {
    /** Text-only segment. */
    data class TextOnly(
        val text: String,
    ) : CatSegmentedControlContent()

    /** Icon-only segment. */
    data class IconOnly(
        val painter: Painter,
        val contentDescription: String? = null,
    ) : CatSegmentedControlContent()

    /** Segment with both an icon and a text label. */
    data class IconText(
        val painter: Painter,
        val text: String,
        val placement: CatSegmentedControlPlacement = CatSegmentedControlPlacement.Leading,
        val iconContentDescription: String? = null,
    ) : CatSegmentedControlContent()
}

/**
 * A single selectable segment.
 *
 * @param value   Stable value reported back through [CatSegmentedControl]'s
 *                `onSelectionChange` callback.
 * @param content Visible content for the segment.
 * @param enabled Per-item enabled state. When false the segment is shown in the
 *                disabled state and ignores taps even if the parent is enabled.
 */
data class CatSegmentedControlItem<T>(
    val value: T,
    val content: CatSegmentedControlContent,
    val enabled: Boolean = true,
)
