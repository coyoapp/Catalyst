package com.haiilo.catalyst.components.alerts

import androidx.compose.ui.graphics.Color

// ---------------------------------------------------------------------------
// CatAlertColors
//
// Holds the resolved color values for a single CatAlert instance.
// All three visual surfaces (border, icon, text) share the same semantic
// color so the alert reads as a unified, consistently colored card.
//
// Analogous to CatButtonStateColorStyle in the buttons package.
// ---------------------------------------------------------------------------

/**
 * Resolved color values for a single [CatAlert] instance.
 *
 * Pass a fully constructed [CatAlertColors] to [CatAlert]'s `style` parameter
 * to bypass the default token resolution entirely. This is an escape hatch for
 * one-off styling and should not be used for standard design-system usage.
 *
 * @param border     Color applied to the outer border of the alert card.
 * @param icon       Tint color applied to the leading icon.
 * @param text       Color applied to the heading text.
 * @param background Background fill of the alert card. Defaults to
 *                   [Color.Transparent] so the alert inherits whatever
 *                   surface it is placed on — the same approach used by the
 *                   Outlined/Text/Link [CatButton] variants.
 */
data class CatAlertColors(
    val border: Color,
    val icon: Color,
    val text: Color,
    val background: Color = Color.Transparent,
)

