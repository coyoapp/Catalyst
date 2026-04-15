package com.haiilo.catalyst.theme

import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Typography
import androidx.compose.runtime.Composable
import androidx.compose.runtime.CompositionLocalProvider
import com.haiilo.catalyst.tokens.generated.CatTypography

private val catMaterialTypography = Typography(
    displayLarge = CatTypography.h1,
    displayMedium = CatTypography.h2,
    displaySmall = CatTypography.h3,
    headlineLarge = CatTypography.h1,
    headlineMedium = CatTypography.h2,
    headlineSmall = CatTypography.h3,
    titleLarge = CatTypography.h4,
    titleMedium = CatTypography.s1,
    titleSmall = CatTypography.s2,
    bodyLarge = CatTypography.body1,
    bodyMedium = CatTypography.body2,
    bodySmall = CatTypography.caption,
    labelLarge = CatTypography.button1,
    labelMedium = CatTypography.button2,
    labelSmall = CatTypography.overline,
)

@Composable
fun CatTheme(
    darkTheme: Boolean = false,
    content: @Composable () -> Unit,
) {
    CompositionLocalProvider(
        LocalCatAccentPalette provides CatThemeConfig.accentPalette,
    ) {
        MaterialTheme(
            typography = catMaterialTypography,
            content = content,
        )
    }
}
