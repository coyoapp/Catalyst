package com.haiilo.catalystdemo

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.unit.dp
import com.haiilo.catalyst.R
import com.haiilo.catalyst.components.buttons.CatButton
import com.haiilo.catalyst.components.buttons.CatButtonColor
import com.haiilo.catalyst.components.buttons.CatButtonContent
import com.haiilo.catalyst.components.buttons.CatButtonVariant
import com.haiilo.catalyst.components.buttons.CatButtonPlacement
import com.haiilo.catalyst.theme.CatTheme
import com.haiilo.catalyst.theme.CatThemeConfig
import com.haiilo.catalyst.tokens.generated.CatSpacing
import com.haiilo.catalyst.tokens.generated.CatTypography

// ---------------------------------------------------------------------------
// Simple screen enum for lightweight navigation (no Jetpack Nav dependency)
// ---------------------------------------------------------------------------

private enum class DemoDestination { Main, Buttons }

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        // Whitelabel: set brand accent color before setContent so CatTheme
        // picks it up automatically for all CatButton(color = Primary) buttons.
        CatThemeConfig.configure("#1A73E8")
        setContent {
            AppNavigation()
        }
    }
}

@Composable
private fun AppNavigation() {
    var destination by remember { mutableStateOf(DemoDestination.Main) }

    when (destination) {
        DemoDestination.Main ->
            DemoScreen(onNavigateToButtons = { destination = DemoDestination.Buttons })

        DemoDestination.Buttons ->
            ButtonsDemoScreen(onBack = { destination = DemoDestination.Main })
    }
}

@Composable
fun DemoScreen(onNavigateToButtons: () -> Unit = {}) {
    CatTheme {
        Surface(
            modifier = Modifier.fillMaxSize(),
            color = MaterialTheme.colorScheme.background,
        ) {
            Column(
                modifier = Modifier
                    .padding(top = 100.dp)
                    .padding(16.dp)
                    .fillMaxSize(),
                verticalArrangement = Arrangement.spacedBy(16.dp),
            ) {
                Text("Design System Demo", style = CatTypography.h1)
                // ---------------------------------------------------------------
                // Navigation to Buttons demo
                // ---------------------------------------------------------------
                Text("Components", style = CatTypography.h3)

                CatButton(
                    modifier = Modifier.fillMaxWidth(),
                    content = CatButtonContent.IconText(
                        painter = painterResource(id = R.drawable.icon_checkmark),
                        text = "View All Buttons",
                        CatButtonPlacement.Trailing
                    ),
                    onClick = onNavigateToButtons,
                    variant = CatButtonVariant.Filled,
                    color = CatButtonColor.Primary,
                )

                HorizontalDivider(modifier = Modifier.padding(vertical = CatSpacing.spacing_md))
            }
        }
    }
}
