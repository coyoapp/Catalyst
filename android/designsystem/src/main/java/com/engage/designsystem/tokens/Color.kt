package com.engage.designsystem.tokens
import androidx.compose.material3.darkColorScheme
import androidx.compose.material3.lightColorScheme
import androidx.compose.ui.graphics.Color

object DSColorsTest {
    val PrimaryBlue = Color(0xFF0ABAB5)
    val SecondaryBlue = Color(0xFF0FC6CC)
    val Background = Color(0xFFE3E7EA)
    val TextPrimary = Color(0xFF1A1A1A)
    val TextSecondary = Color(0xFF666666)

    // Material3 color roles
    val Primary = PrimaryBlue
    val OnPrimary = TextPrimary
    val Secondary = SecondaryBlue
    val OnSecondary = TextPrimary
    val OnBackground = TextPrimary
    val Surface = Color.White
    val OnSurface = TextSecondary
}

val LightColorsTest = lightColorScheme(
    primary = DSColorsTest.Primary,
    onPrimary = DSColorsTest.OnPrimary,
    secondary = DSColorsTest.Secondary,
    onSecondary = DSColorsTest.OnSecondary,
    background = DSColorsTest.Background,
    onBackground = DSColorsTest.OnBackground,
    surface = DSColorsTest.Surface,
    onSurface = DSColorsTest.OnSurface
)

object DSColorsDarkTest {
    val PrimaryBlue = Color(0xFF0ABAB5)   // keep the same for brand identity
    val SecondaryBlue = Color(0xFF0FC6CC) // keep the same for brand identity
    val Background = Color(0xFF121212)    // dark gray, standard for dark theme
    val TextPrimary = Color(0xFFE3E7EA)   // light gray, matches your light background
    val TextSecondary = Color(0xFFB0B0B0) // softer gray for secondary text

    // Material3 color roles (dark)
    val Primary = PrimaryBlue
    val OnPrimary = Color.White
    val Secondary = SecondaryBlue
    val OnSecondary = Color.White
    val OnBackground = TextPrimary
    val Surface = Color(0xFF1E1E1E)       // slightly lighter than background
    val OnSurface = TextSecondary
}

val DarkColorsTest = darkColorScheme(
    primary = DSColorsDarkTest.Primary,
    onPrimary = DSColorsDarkTest.OnPrimary,
    secondary = DSColorsDarkTest.Secondary,
    onSecondary = DSColorsDarkTest.OnSecondary,
    background = DSColorsDarkTest.Background,
    onBackground = DSColorsDarkTest.OnBackground,
    surface = DSColorsDarkTest.Surface,
    onSurface = DSColorsDarkTest.OnSurface
)
