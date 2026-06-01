package com.haiilo.catalyst.components.alerts

import androidx.compose.ui.graphics.Color
import com.haiilo.catalyst.theme.CatColorPalette
import com.haiilo.catalyst.tokens.generated.CatColors
import org.junit.Assert.assertEquals
import org.junit.Test

class CatAlertDefaultsTest {

    private val testAccentPalette = CatColorPalette(
        bg = Color(0xFF1A73E8),
        bgHover = Color(0xFF1867D2),
        bgActive = Color(0xFF1559B7),
        fill = Color.White,
        fillHover = Color.White,
        fillActive = Color.White,
        text = Color(0xFF1A73E8),
        textHover = Color(0xFF1867D2),
        textActive = Color(0xFF1559B7),
    )

    @Test
    fun primary_withoutAccent_usesPrimaryThemeText() {
        val colors = CatAlertDefaults.colors(CatAlertColor.Primary)

        assertEquals(CatColors.Theme.Primary.text, colors.icon)
        assertEquals(CatColors.Theme.Primary.text, colors.text)
        assertEquals(CatColors.Theme.Primary.text.copy(alpha = 0.30f), colors.border)
        assertEquals(Color.Transparent, colors.background)
    }

    @Test
    fun primary_withAccent_usesAccentPalette() {
        val colors = CatAlertDefaults.colors(
            color = CatAlertColor.Primary,
            accentPalette = testAccentPalette,
        )

        assertEquals(testAccentPalette.text, colors.icon)
        assertEquals(testAccentPalette.text, colors.text)
        assertEquals(testAccentPalette.text.copy(alpha = 0.30f), colors.border)
    }

    @Test
    fun nonPrimary_withAccent_ignoresAccentPalette() {
        val colors = CatAlertDefaults.colors(
            color = CatAlertColor.Info,
            accentPalette = testAccentPalette,
        )

        assertEquals(CatColors.Theme.Info.text, colors.icon)
        assertEquals(CatColors.Theme.Info.text, colors.text)
        assertEquals(CatColors.Theme.Info.text.copy(alpha = 0.30f), colors.border)
    }
}

