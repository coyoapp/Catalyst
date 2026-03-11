package com.haiilo.catalyst.components.buttons

import androidx.compose.ui.graphics.Color

// ---------------------------------------------------------------------------
// CatButtonStateColorStyle
// Holds the three color channels for a single interaction state.
// ---------------------------------------------------------------------------

data class CatButtonStateColorStyle(
    val background: Color,
    val foreground: Color,
    val border: Color,
)

// ---------------------------------------------------------------------------
// CatButtonStateStyle
// Combines color style with visual state properties for one interaction state.
// ---------------------------------------------------------------------------

data class CatButtonStateStyle(
    val colorStyle: CatButtonStateColorStyle,
    /** Whether the label should be underlined (used by the Link variant on press). */
    val isUnderlined: Boolean = false,
    /** Scale transform applied during the state (reserved for future animation). */
    val scale: Float = 1f,
)

// ---------------------------------------------------------------------------
// CatButtonState
// Full per-state style for a button (normal / pressed / focused / disabled).
// Note: `hovered` is omitted — not applicable on Android touch targets.
// ---------------------------------------------------------------------------

data class CatButtonState(
    val normal: CatButtonStateStyle,
    val pressed: CatButtonStateStyle,
    val focused: CatButtonStateStyle,
    val disabled: CatButtonStateStyle,
)
