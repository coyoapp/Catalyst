package com.haiilo.catalystdemo

import android.app.Application
import androidx.compose.ui.text.font.Font
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontStyle
import androidx.compose.ui.text.font.FontWeight
import com.haiilo.catalyst.CatFontFamily

/**
 * Application entry point.
 *
 * This is the right place to inject a brand font into Catalyst before any
 * Activity renders. Add your font TTF files to `app/src/main/res/font/` and
 * reference them here. Catalyst will fall back to Lato if this is omitted.
 *
 * Example — once the WL font files are available in res/font/:
 *
 * ```kotlin
 * CatFontFamily.current = FontFamily(
 *     Font(R.font.wl_regular,         FontWeight.Normal),
 *     Font(R.font.wl_italic,          FontWeight.Normal,   FontStyle.Italic),
 *     Font(R.font.wl_semibold,        FontWeight.SemiBold),
 *     Font(R.font.wl_semibold_italic, FontWeight.SemiBold, FontStyle.Italic),
 *     Font(R.font.wl_bold,            FontWeight.Bold),
 * )
 * ```
 */
class CatalystDemoApp : Application() {
    override fun onCreate() {
        super.onCreate()

        // TODO: Replace with WL FontFamily once font TTFs are added to res/font/.
        // CatFontFamily.current = FontFamily(
        //     Font(R.font.wl_regular,         FontWeight.Normal),
        //     Font(R.font.wl_italic,          FontWeight.Normal,   FontStyle.Italic),
        //     Font(R.font.wl_semibold,        FontWeight.SemiBold),
        //     Font(R.font.wl_semibold_italic, FontWeight.SemiBold, FontStyle.Italic),
        //     Font(R.font.wl_bold,            FontWeight.Bold),
        // )
    }
}
