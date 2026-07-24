// CatToastMsgEnums.kt
// Catalyst
//
// Created by Catalyst Agent on 2026-07-21.
//

package com.haiilo.catalyst.components.toastmsg

// ---------------------------------------------------------------------------
// CatToastMsgVariant — layout mode for the toast
// ---------------------------------------------------------------------------

/**
 * Layout mode for [CatToastMsg].
 *
 * - [Compact]: Single-row layout. Icon + title + action + dismiss all inline.
 *   Fixed height: 56 dp.
 * - [Expanded]: Stacked layout. Title can wrap to multiple lines; action sits
 *   below the title. Dismiss button stays anchored top-end. Fixed width: 343 dp.
 */
enum class CatToastMsgVariant {
    /** Single-row layout, 56 dp tall. */
    Compact,

    /** Stacked layout, multi-line title, action below title. */
    Expanded,
}
