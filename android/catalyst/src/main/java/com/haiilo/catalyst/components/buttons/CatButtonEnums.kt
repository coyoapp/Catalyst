package com.haiilo.catalyst.components.buttons

import androidx.compose.ui.graphics.painter.Painter
import androidx.compose.ui.unit.Dp
import com.haiilo.catalyst.tokens.generated.CatSpacing

// ---------------------------------------------------------------------------
// Variant — visual shape of the button
// ---------------------------------------------------------------------------

enum class CatButtonVariant {
    /** Solid background, filled foreground. */
    Filled,

    /** Transparent background, colored border and text. */
    Outlined,

    /** Ghost — transparent background, no border, colored text. */
    Text,

    /** Transparent, no border, always underlined on Android (no hover). */
    Link,
}

// ---------------------------------------------------------------------------
// Color config — semantic color role
// ---------------------------------------------------------------------------

enum class CatButtonColor {
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
// Size — controls button height AND horizontal padding.
//
// Values sourced directly from Figma "Variables" annotations per button size:
//
//   Small  → height = spacing4Xl (32 dp)  hPadding = spacingMd  (8 dp)
//   Medium → height = spacing5Xl (40 dp)  hPadding = spacingXl  (16 dp)
//   Large  → height = spacing6Xl (48 dp)  hPadding = spacingXl  (16 dp)
//
// Vertical padding (spacingLg = 12 dp) and icon-text gap (spacingXs = 4 dp)
// are the same across all sizes.
// ---------------------------------------------------------------------------

sealed class CatButtonSize {
    /** 32 dp tall, 8 dp horizontal padding. */
    data object Small : CatButtonSize()

    /** 40 dp tall, 16 dp horizontal padding (default). */
    data object Medium : CatButtonSize()

    /** 48 dp tall, 16 dp horizontal padding. */
    data object Large : CatButtonSize()

    /** Arbitrary height; caller supplies horizontal padding via [horizontalPadding]. */
    data class Custom(
        val height: Dp,
        val horizontalPadding: Dp = CatSpacing.spacing_xl,
    ) : CatButtonSize()

    /** Total button height from design tokens. */
    val heightDp: Dp
        get() = when (this) {
            is Small -> CatSpacing.spacing_4xl // 32 dp
            is Medium -> CatSpacing.spacing_5xl // 40 dp
            is Large -> CatSpacing.spacing_6xl // 48 dp
            is Custom -> height
        }

    /** Horizontal (start + end) content padding from design tokens. */
    val horizontalPaddingDp: Dp
        get() = when (this) {
            is Small -> CatSpacing.spacing_md // 8 dp
            is Medium -> CatSpacing.spacing_xl // 16 dp
            is Large -> CatSpacing.spacing_xl // 16 dp
            is Custom -> horizontalPadding
        }
}

// ---------------------------------------------------------------------------
// Placement — icon position relative to text
// ---------------------------------------------------------------------------

enum class CatButtonPlacement {
    Leading,
    Trailing,
}

// ---------------------------------------------------------------------------
// Content — what the button displays
// ---------------------------------------------------------------------------

sealed class CatButtonContent {
    /** Text-only button. */
    data class TextOnly(val text: String) : CatButtonContent()

    /** Icon-only button. */
    data class IconOnly(
        val painter: Painter,
        val contentDescription: String? = null,
    ) : CatButtonContent()

    /** Button with both an icon and a text label. */
    data class IconText(
        val painter: Painter,
        val text: String,
        val placement: CatButtonPlacement = CatButtonPlacement.Leading,
        val iconContentDescription: String? = null,
    ) : CatButtonContent()
}
