package com.engage.designsystem.theme

import androidx.compose.material3.MaterialTheme
import androidx.compose.runtime.Composable
import com.engage.designsystem.tokens.DSTypography.EngageTypography
import com.engage.designsystem.tokens.DarkColors
import com.engage.designsystem.tokens.LightColors

@Composable
fun EngageTheme(
    darkTheme: Boolean = false,
    content: @Composable () -> Unit
) {
    val colors = if (darkTheme) DarkColors else LightColors
    MaterialTheme(
        colorScheme = colors,
        typography = EngageTypography,
        content = content
    )
}


