package com.haiilo.catalyst.theme

import androidx.compose.material3.MaterialTheme
import androidx.compose.runtime.Composable
import com.haiilo.catalyst.tokens.DSTypographyTest.EngageTypography
import com.haiilo.catalyst.tokens.generated.DSColors

@Composable
fun EngageTheme(
    darkTheme: Boolean = false,
    content: @Composable () -> Unit
) {
    MaterialTheme(
//        colorScheme = colors, // Theme works with color schemes so wont be able to use DSColors directly
        typography = EngageTypography,
        content = content
    )
}


