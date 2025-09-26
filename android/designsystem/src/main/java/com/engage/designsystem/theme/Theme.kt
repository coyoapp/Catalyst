package com.engage.designsystem.theme

import androidx.compose.material3.MaterialTheme
import androidx.compose.runtime.Composable
import com.engage.designsystem.tokens.DSTypographyTest.EngageTypography
import com.engage.designsystem.tokens.DarkColorsTest
import com.engage.designsystem.tokens.LightColorsTest

@Composable
fun EngageTheme(
    darkTheme: Boolean = false,
    content: @Composable () -> Unit
) {
    val colors = if (darkTheme) DarkColorsTest else LightColorsTest
    MaterialTheme(
        colorScheme = colors,
        typography = EngageTypography,
        content = content
    )
}


