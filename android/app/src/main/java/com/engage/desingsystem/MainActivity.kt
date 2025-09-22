package com.engage.desingsystem

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.tooling.preview.Preview
import com.engage.designsystem.components.PrimaryButton
import com.engage.designsystem.theme.EngageTheme
import com.engage.designsystem.tokens.DSTypography
import androidx.compose.foundation.layout.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.unit.dp
import com.engage.designsystem.components.PrimaryButton
import com.engage.designsystem.theme.EngageTheme

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContent {
            DemoScreen()
        }
    }
}

@Composable
fun DemoScreen() {
    var darkTheme by remember { mutableStateOf(false) }

    EngageTheme(darkTheme = darkTheme) {
        Surface(
            modifier = Modifier.fillMaxSize(),
            color = MaterialTheme.colorScheme.background
        ) {
            Column(
                modifier = Modifier
                    .padding(top = 100.dp)
                    .padding(16.dp)
                    .fillMaxSize(),
                verticalArrangement = Arrangement.spacedBy(16.dp)
            ) {
                Text("Design System Demo", style = DSTypography.EngageTypography.titleLarge)
                Text("This is body text using DS typography.", style = DSTypography.EngageTypography.bodyLarge)
                Text("This is a caption.", style = DSTypography.EngageTypography.labelLarge)

                PrimaryButton(
                    text = if (darkTheme) "Switch to Light" else "Switch to Dark",
                    onClick = { darkTheme = !darkTheme }
                )
            }
        }
    }
}
