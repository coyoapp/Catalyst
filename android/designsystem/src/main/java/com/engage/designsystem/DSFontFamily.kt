package com.engage.designsystem

import androidx.compose.ui.text.font.Font
import androidx.compose.ui.text.font.FontFamily
// ✅ CRITICAL: Import the R file from your LIBRARY, not the app
import com.engage.designsystem.R

object DSFontFamily {
    val lato = FontFamily(
        Font(R.font.lato)
    )
}
