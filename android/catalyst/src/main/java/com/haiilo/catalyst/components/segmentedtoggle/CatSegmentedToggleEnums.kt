package com.haiilo.catalyst.components.segmentedtoggle

import androidx.compose.ui.graphics.painter.Painter
import androidx.compose.ui.unit.Dp
import com.haiilo.catalyst.tokens.generated.CatSpacing

// ---------------------------------------------------------------------------
// CatSegmentedToggleColor — semantic color role for the selected segment
// ---------------------------------------------------------------------------

enum class CatSegmentedToggleColor {
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

sealed class CatSegmentedToggleSize {
    /** 32 dp tall, 8 dp horizontal padding. */
    data object XSmall : CatSegmentedToggleSize()

    /** 40 dp tall, 16 dp horizontal padding. */
    data object Small : CatSegmentedToggleSize()

    /** 48 dp tall, 16 dp horizontal padding (default). */
    data object Medium : CatSegmentedToggleSize()

    /** Arbitrary height; caller supplies horizontal padding via [horizontalPadding]. */
    data class Custom(
        val height: Dp,
        val horizontalPadding: Dp = CatSpacing.spacing_xl,
    ) : CatSegmentedToggleSize()

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

enum class CatSegmentedTogglePlacement {
    Leading,
    Trailing,
}

// ---------------------------------------------------------------------------
// Content — what an individual segment displays
// ---------------------------------------------------------------------------

sealed class CatSegmentedToggleContent {
    /** Text-only segment. */
    data class TextOnly(
        val text: String,
    ) : CatSegmentedToggleContent()

    /** Icon-only segment. */
    data class IconOnly(
        val painter: Painter,
        val contentDescription: String? = null,
    ) : CatSegmentedToggleContent()

    /** Segment with both an icon and a text label. */
    data class IconText(
        val painter: Painter,
        val text: String,
        val placement: CatSegmentedTogglePlacement = CatSegmentedTogglePlacement.Leading,
        val iconContentDescription: String? = null,
    ) : CatSegmentedToggleContent()
}

/**
 * A single selectable segment.
 *
 * @param value   Stable value reported back through [CatSegmentedToggle]'s
 *                `onSelectionChange` callback.
 * @param content Visible content for the segment.
 * @param enabled Per-item enabled state. When false the segment is shown in the
 *                disabled state and ignores taps even if the parent is enabled.
 */
data class CatSegmentedToggleItem<T>(
    val value: T,
    val content: CatSegmentedToggleContent,
    val enabled: Boolean = true,
)
