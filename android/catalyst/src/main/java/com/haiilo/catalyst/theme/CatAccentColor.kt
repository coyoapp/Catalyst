package com.haiilo.catalyst.theme

import androidx.compose.runtime.Composable
import androidx.compose.runtime.CompositionLocalProvider
import androidx.compose.runtime.compositionLocalOf
import androidx.compose.ui.graphics.Color
import com.haiilo.catalyst.theme.CatColorPalette

// ---------------------------------------------------------------------------
// LocalCatAccentPalette
//
// Composition local that carries the host app's brand accent palette through
// the composition tree. Set globally via CatTheme (reads CatThemeConfig) and
// overridable per-subtree via ProvideAccentColor.
//
// Mirrors `.catalystAccentColor(_:)` / `catalystAccentPalette` on iOS.
// ---------------------------------------------------------------------------

/** Provides the current accent [CatColorPalette] to descendant composables. */
val LocalCatAccentPalette = compositionLocalOf<CatColorPalette?> { null }

/**
 * Overrides the Catalyst accent color for all [CatButton]s inside [content].
 *
 * Use this when a single screen or component tree needs a different brand
 * color than the app-wide default set via [CatThemeConfig.configure].
 *
 * ```kotlin
 * ProvideAccentColor(Color(0xFF1A73E8)) {
 *     CatButton(CatButtonContent.TextOnly("Save"), onClick = { … })
 * }
 * ```
 *
 * Mirrors `ProvideAccentColor {}` / `.catalystAccentColor(_:)` on iOS.
 */
@Composable
fun ProvideAccentColor(
    color: Color,
    content: @Composable () -> Unit,
) {
    CompositionLocalProvider(
        LocalCatAccentPalette provides CatColorPalette.fromAccentColor(color),
        content = content,
    )
}
