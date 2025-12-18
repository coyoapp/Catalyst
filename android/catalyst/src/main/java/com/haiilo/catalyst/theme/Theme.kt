package com.haiilo.catalyst.theme

import androidx.compose.material3.MaterialTheme
import androidx.compose.runtime.Composable
import com.haiilo.catalyst.tokens.CatTypographyTest.CatTypography

@Composable
fun CatTheme(
    darkTheme: Boolean = false,
    content: @Composable () -> Unit
) {
    MaterialTheme(
//        colorScheme = colors, // Theme works with color schemes so wont be able to use DSColors directly
        typography = CatTypography,
        content = content
    )
}


