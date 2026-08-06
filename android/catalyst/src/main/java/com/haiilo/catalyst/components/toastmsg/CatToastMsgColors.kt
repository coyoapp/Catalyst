// CatToastMsgColors.kt
// Catalyst
//
// Created by Catalyst Agent on 2026-07-21.
//
// Display profile — single resolved color state (no state machine).
// Reference: CatAlertColors (inline in CatAlertDefaults.kt)

package com.haiilo.catalyst.components.toastmsg

import androidx.compose.ui.graphics.Color

// ---------------------------------------------------------------------------
// CatToastMsgColors
//
// Flat resolved color set for one toast. No interaction-state matrix —
// the toast surface is display-only. Only the internal dismiss button and the
// consumer-supplied action slot are tappable, and each carries its own styling.
// ---------------------------------------------------------------------------

data class CatToastMsgColors(
    /** Dark surface background (`color.ui.background.surfaceInverted`). */
    val background: Color,
    /** Inverted (light) color for title text and status icon (`color.ui.font.bodyInverted`). */
    val foreground: Color,
    /** Accent-aware color for the action button label (`color.theme.primaryInverted.text`). */
    val actionColor: Color,
)
