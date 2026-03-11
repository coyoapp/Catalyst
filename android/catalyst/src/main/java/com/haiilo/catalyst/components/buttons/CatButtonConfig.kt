package com.haiilo.catalyst.components.buttons

import androidx.compose.runtime.Composable
import androidx.compose.runtime.CompositionLocalProvider
import androidx.compose.runtime.compositionLocalOf

// ---------------------------------------------------------------------------
// CatButtonConfig
//
// Holds the default variant and color injected into the composition
// tree via [LocalCatButtonConfig].  Any [CatButton] that does not receive
// explicit variant/color parameters will read from this local.
// ---------------------------------------------------------------------------

data class CatButtonConfig(
    val variant: CatButtonVariant = CatButtonVariant.Filled,
    val color: CatButtonColor = CatButtonColor.Primary,
)

/**
 * CompositionLocal that carries the ambient [CatButtonConfig] down the
 * composition tree.  Defaults to [CatButtonConfig] (Filled + Primary).
 */
val LocalCatButtonConfig = compositionLocalOf { CatButtonConfig() }

// ---------------------------------------------------------------------------
// ProvideCatButtonConfig
//
// Convenience composable that overrides [LocalCatButtonConfig] for its
// subtree.
// ---------------------------------------------------------------------------

/**
 * Overrides the ambient [CatButtonConfig] for all [CatButton]s inside
 * [content].
 *
 * Usage:
 * ```kotlin
 * ProvideCatButtonConfig(
 *     variant = CatButtonVariant.Outlined,
 *     color = CatButtonColor.Danger,
 * ) {
 *     CatButton(CatButtonContent.TextOnly("Delete"), onClick = { ... })
 * }
 * ```
 */
@Composable
fun ProvideCatButtonConfig(
    variant: CatButtonVariant,
    color: CatButtonColor,
    content: @Composable () -> Unit,
) {
    CompositionLocalProvider(
        LocalCatButtonConfig provides CatButtonConfig(variant = variant, color = color),
        content = content,
    )
}
