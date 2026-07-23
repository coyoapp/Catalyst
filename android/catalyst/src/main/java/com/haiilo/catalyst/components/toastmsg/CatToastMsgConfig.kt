// CatToastMsgConfig.kt
// Catalyst
//
// Created by Catalyst Agent on 2026-07-21.
//
// !! GENERATED — REVIEW review.md THEN MOVE TO SOURCE !!
// Destination: android/catalyst/src/main/java/com/haiilo/catalyst/components/toastmsg/
//
// CompositionLocal config — same pattern as CatAlertConfig.kt

package com.haiilo.catalyst.components.toastmsg

import androidx.compose.runtime.Composable
import androidx.compose.runtime.CompositionLocalProvider
import androidx.compose.runtime.compositionLocalOf

// ---------------------------------------------------------------------------
// CatToastMsgConfig + CompositionLocal
// ---------------------------------------------------------------------------

data class CatToastMsgConfig(
    val variant: CatToastMsgVariant = CatToastMsgVariant.Compact,
)

val LocalCatToastMsgConfig = compositionLocalOf { CatToastMsgConfig() }

@Composable
fun ProvideCatToastMsgConfig(
    variant: CatToastMsgVariant,
    content: @Composable () -> Unit,
) {
    CompositionLocalProvider(
        LocalCatToastMsgConfig provides CatToastMsgConfig(variant = variant),
        content = content,
    )
}
