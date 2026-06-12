package com.haiilo.catalyst.components.alerts

import androidx.compose.runtime.Composable
import androidx.compose.runtime.CompositionLocalProvider
import androidx.compose.runtime.compositionLocalOf

// ---------------------------------------------------------------------------
// CatAlertConfig
//
// Holds the default color injected into the composition tree via
// [LocalCatAlertConfig]. Any [CatAlert] that does not receive an explicit
// [color] parameter will read from this local.
//
// Analogous to CatButtonConfig in the buttons package.
// ---------------------------------------------------------------------------

/**
 * Default configuration carried through the composition tree for [CatAlert].
 *
 * @param color  Semantic color role applied to alerts that do not supply
 *               their own [CatAlert.color] parameter.
 */
data class CatAlertConfig(
    val color: CatAlertColor = CatAlertColor.Info,
)

/**
 * CompositionLocal that carries the ambient [CatAlertConfig] down the
 * composition tree. Defaults to [CatAlertConfig] ([CatAlertColor.Info]).
 */
val LocalCatAlertConfig = compositionLocalOf { CatAlertConfig() }

// ---------------------------------------------------------------------------
// ProvideCatAlertConfig
//
// Convenience composable that overrides [LocalCatAlertConfig] for its
// subtree.
// ---------------------------------------------------------------------------

/**
 * Overrides the ambient [CatAlertConfig] for all [CatAlert]s inside [content].
 *
 * Usage:
 * ```kotlin
 * ProvideCatAlertConfig(color = CatAlertColor.Warning) {
 *     CatAlert(heading = "Alert A", ...) // inherits Warning
 *     CatAlert(heading = "Alert B", ...) // inherits Warning
 *     CatAlert(heading = "Override", color = CatAlertColor.Danger, ...) // overrides at call site
 * }
 * ```
 */
@Composable
fun ProvideCatAlertConfig(
    color: CatAlertColor,
    content: @Composable () -> Unit,
) {
    CompositionLocalProvider(
        LocalCatAlertConfig provides CatAlertConfig(color = color),
        content = content,
    )
}
