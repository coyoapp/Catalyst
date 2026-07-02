package com.haiilo.catalyst.components.segmentedtoggle

import androidx.compose.ui.graphics.Color
import com.haiilo.catalyst.theme.CatColorPalette
import com.haiilo.catalyst.tokens.generated.CatColors
import org.junit.Assert.assertEquals
import org.junit.Test

class CatSegmentedToggleDefaultsTest {
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
    fun primary_withoutAccent_usesPrimaryThemePalette() {
        val colors = CatSegmentedToggleDefaults.colors(CatSegmentedToggleColor.Primary)

        assertEquals(CatColors.Ui.Background.muted, colors.containerBackground)
        assertEquals(CatColors.Ui.Border.regular, colors.containerBorder)
        assertEquals(CatColors.Ui.Background.surface, colors.itemColors.selected.background)
        assertEquals(CatColors.Theme.Primary.text, colors.itemColors.selected.foreground)
        assertEquals(CatColors.Ui.Font.muted, colors.itemColors.unselected.foreground)
    }

    @Test
    fun primary_withAccent_usesAccentPalette() {
        val colors = CatSegmentedToggleDefaults.colors(
            color = CatSegmentedToggleColor.Primary,
            accentPalette = testAccentPalette,
        )

        assertEquals(CatColors.Ui.Background.surface, colors.itemColors.selected.background)
        assertEquals(testAccentPalette.text, colors.itemColors.selected.foreground)
        assertEquals(CatColors.Ui.Font.muted, colors.itemColors.unselected.foreground)
        assertEquals(
            CatColors.Ui.Background.surface
                .copy(alpha = 0.72f),
            colors.itemColors.unselectedPressed.background,
        )
    }

    @Test
    fun nonPrimary_withAccent_ignoresAccentPalette() {
        val colors = CatSegmentedToggleDefaults.colors(
            color = CatSegmentedToggleColor.Info,
            accentPalette = testAccentPalette,
        )

        assertEquals(CatColors.Ui.Background.surface, colors.itemColors.selected.background)
        assertEquals(CatColors.Theme.Info.text, colors.itemColors.selected.foreground)
        assertEquals(CatColors.Ui.Font.muted, colors.itemColors.unselected.foreground)
    }
}
