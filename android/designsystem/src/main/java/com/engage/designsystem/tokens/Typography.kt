package com.engage.designsystem.tokens

import androidx.compose.material3.Typography
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.Font
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.sp
import com.engage.designsystem.R

//private val HaiiloFontFamily = FontFamily(
//    Font(R.font.light, FontWeight.W300),
//    Font(R.font.regular, FontWeight.W400),
//    Font(R.font.semibold, FontWeight.W500),
//    Font(R.font.bold, FontWeight.W600)
//)

// There is one HaiiloFontFamily which is not correct but can make an example
object DSTypography {
    val EngageTypography = Typography(
        displayLarge = TextStyle(
            fontFamily = FontFamily.SansSerif,
            fontWeight = FontWeight.Bold,
            fontSize = 57.sp,
            lineHeight = 64.sp,
            letterSpacing = (-0.25).sp
        ),
        headlineMedium = TextStyle(
            fontFamily = FontFamily.SansSerif,
            fontWeight = FontWeight.SemiBold,
            fontSize = 28.sp,
            lineHeight = 36.sp
        ),
        titleMedium = TextStyle(
            fontFamily = FontFamily.SansSerif,
            fontWeight = FontWeight.Medium,
            fontSize = 16.sp,
            lineHeight = 24.sp
        ),
        bodyLarge = TextStyle(
            fontFamily = FontFamily.SansSerif,
            fontWeight = FontWeight.Normal,
            fontSize = 16.sp,
            lineHeight = 24.sp
        ),
        labelLarge = TextStyle(
            fontFamily = FontFamily.SansSerif,
            fontWeight = FontWeight.Medium,
            fontSize = 14.sp,
            lineHeight = 20.sp
        )
    )
}
