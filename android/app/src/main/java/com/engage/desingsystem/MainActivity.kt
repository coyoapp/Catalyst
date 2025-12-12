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
import com.haiilo.catalyst.components.PrimaryButton
import com.haiilo.catalyst.theme.EngageTheme
import androidx.compose.foundation.layout.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.unit.dp
import com.haiilo.catalyst.components.PrimaryButton
import com.haiilo.catalyst.components.PrimaryButtonWithTheme
import com.haiilo.catalyst.theme.EngageTheme
import com.haiilo.catalyst.R
import com.haiilo.catalyst.tokens.generated.CatTypography

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
                Text("Design System Demo", style = CatTypography.h1)
                Text("This is body text using DS typography.", style = CatTypography.body1)
                Text("This is a caption.", style = CatTypography.body2)

                Icon(
                    painter = painterResource(id = R.drawable.reaction_appreciate),
                    contentDescription = "Appreciate",
                    tint = Color.Unspecified
                )

                Icon(
                    painter = painterResource(id = R.drawable.union),
                    contentDescription = "Union",
                    tint = Color.Unspecified
                )

                PrimaryButton(
                    text = if (darkTheme) "Switch to Light" else "Switch to Dark",
                    onClick = { darkTheme = !darkTheme }
                )

                PrimaryButtonWithTheme(
                    text = if (darkTheme) "Themed to Light" else "Themed to Dark",
                    onClick = { darkTheme = !darkTheme }
                )
            }
        }
    }
}
