package com.haiilo.catalystdemo

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.painterResource
import com.haiilo.catalyst.R
import com.haiilo.catalyst.components.alerts.CatAlert
import com.haiilo.catalyst.components.alerts.CatAlertButtonPlacement
import com.haiilo.catalyst.components.alerts.CatAlertColor
import com.haiilo.catalyst.components.buttons.CatButton
import com.haiilo.catalyst.components.buttons.CatButtonColor
import com.haiilo.catalyst.components.buttons.CatButtonContent
import com.haiilo.catalyst.components.buttons.CatButtonVariant
import com.haiilo.catalyst.theme.CatTheme
import com.haiilo.catalyst.tokens.generated.CatSpacing
import com.haiilo.catalyst.tokens.generated.CatTypography

// ---------------------------------------------------------------------------
// AlertsDemoScreen
//
// Demonstrates all CatAlert color roles, button placements, long-heading
// wrapping behaviour, and the disabled state.
// ---------------------------------------------------------------------------

@Composable
fun AlertsDemoScreen(onBack: () -> Unit) {
    CatTheme {
        Surface(
            modifier = Modifier.fillMaxSize(),
            color = MaterialTheme.colorScheme.background,
        ) {
            Column(
                modifier = Modifier
                    .fillMaxSize()
                    .verticalScroll(rememberScrollState())
                    .padding(horizontal = CatSpacing.spacing_xl, vertical = CatSpacing.spacing_4xl),
                verticalArrangement = Arrangement.spacedBy(CatSpacing.spacing_xl),
            ) {
                CatButton(
                    content = CatButtonContent.TextOnly("Back"),
                    onClick = onBack,
                    variant = CatButtonVariant.Text,
                    color = CatButtonColor.Primary,
                )

                Text("Alerts", style = CatTypography.h2)

                // ---------------------------------------------------------------
                // 1. Color roles — Trailing button placement (short heading)
                // ---------------------------------------------------------------
                AlertSectionHeader("Color roles — Trailing button")
                AlertDivider()

                CatAlert(
                    heading = "Info alert",
                    leadingIcon = painterResource(R.drawable.info_circle_outlined),
                    buttonText = "Action",
                    onButtonClick = {},
                    color = CatAlertColor.Info,
                )
                CatAlert(
                    heading = "Primary alert",
                    leadingIcon = painterResource(R.drawable.info_circle_outlined),
                    buttonText = "Action",
                    onButtonClick = {},
                    color = CatAlertColor.Primary,
                )
                CatAlert(
                    heading = "Success alert",
                    leadingIcon = painterResource(R.drawable.icon_checkmark),
                    buttonText = "Action",
                    onButtonClick = {},
                    color = CatAlertColor.Success,
                )
                CatAlert(
                    heading = "Warning alert",
                    leadingIcon = painterResource(R.drawable.info_circle_outlined),
                    buttonText = "Action",
                    onButtonClick = {},
                    color = CatAlertColor.Warning,
                )
                CatAlert(
                    heading = "Danger alert",
                    leadingIcon = painterResource(R.drawable.info_circle_outlined),
                    buttonText = "Action",
                    onButtonClick = {},
                    color = CatAlertColor.Danger,
                )
                CatAlert(
                    heading = "Default alert",
                    leadingIcon = painterResource(R.drawable.info_circle_outlined),
                    buttonText = "Action",
                    onButtonClick = {},
                    color = CatAlertColor.Default,
                )

                AlertDivider()

                // ---------------------------------------------------------------
                // 2. Long heading — Below button placement (multi-line heading)
                // ---------------------------------------------------------------
                AlertSectionHeader("Long heading — Below button")
                AlertDivider()

                CatAlert(
                    heading = "This is a longer heading that needs more than one line to display fully",
                    leadingIcon = painterResource(R.drawable.info_circle_outlined),
                    buttonText = "Action",
                    onButtonClick = {},
                    color = CatAlertColor.Info,
                    buttonPlacement = CatAlertButtonPlacement.Below,
                )
                CatAlert(
                    heading = "This is a longer heading that needs more than one line to display fully",
                    leadingIcon = painterResource(R.drawable.info_circle_outlined),
                    buttonText = "Action",
                    onButtonClick = {},
                    color = CatAlertColor.Warning,
                    buttonPlacement = CatAlertButtonPlacement.Below,
                )
                CatAlert(
                    heading = "This is a longer heading that needs more than one line to display fully",
                    leadingIcon = painterResource(R.drawable.info_circle_outlined),
                    buttonText = "Action",
                    onButtonClick = {},
                    color = CatAlertColor.Danger,
                    buttonPlacement = CatAlertButtonPlacement.Below,
                )

                AlertDivider()

                // ---------------------------------------------------------------
                // 3. Disabled state
                // ---------------------------------------------------------------
                AlertSectionHeader("Disabled")
                AlertDivider()

                CatAlert(
                    heading = "Action is currently unavailable",
                    leadingIcon = painterResource(R.drawable.info_circle_outlined),
                    buttonText = "Action",
                    onButtonClick = {},
                    color = CatAlertColor.Info,
                    enabled = false,
                )
                CatAlert(
                    heading = "This is a longer heading to test disabled with below placement",
                    leadingIcon = painterResource(R.drawable.info_circle_outlined),
                    buttonText = "Action",
                    onButtonClick = {},
                    color = CatAlertColor.Danger,
                    buttonPlacement = CatAlertButtonPlacement.Below,
                    enabled = false,
                )
            }
        }
    }
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

@Composable
private fun AlertSectionHeader(title: String) {
    Text(title, style = CatTypography.s1)
}

@Composable
private fun AlertDivider() {
    HorizontalDivider(
        modifier = Modifier.padding(vertical = CatSpacing.spacing_md),
    )
}
