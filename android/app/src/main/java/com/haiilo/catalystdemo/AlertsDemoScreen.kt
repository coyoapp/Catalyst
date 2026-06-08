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
import com.haiilo.catalyst.components.alerts.ProvideCatAlertConfig
import com.haiilo.catalyst.components.buttons.CatButton
import com.haiilo.catalyst.components.buttons.CatButtonColor
import com.haiilo.catalyst.components.buttons.CatButtonContent
import com.haiilo.catalyst.components.buttons.CatButtonPlacement
import com.haiilo.catalyst.components.buttons.CatButtonSize
import com.haiilo.catalyst.components.buttons.CatButtonVariant
import com.haiilo.catalyst.theme.CatTheme
import com.haiilo.catalyst.tokens.generated.CatSpacing
import com.haiilo.catalyst.tokens.generated.CatTypography

// ---------------------------------------------------------------------------
// AlertsDemoScreen
//
// Demonstrates CatAlert color roles, automatic and explicit placement,
// disabled actions, optional actions, and custom action-slot content.
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

                AlertSectionHeader("Color roles - automatic placement")
                AlertDivider()

                DemoAlert("Info alert", CatAlertColor.Info)
                DemoAlert("Primary alert", CatAlertColor.Primary)
                DemoAlert("Success alert", CatAlertColor.Success, icon = R.drawable.icon_checkmark)
                DemoAlert("Warning alert", CatAlertColor.Warning)
                DemoAlert("Danger alert", CatAlertColor.Danger)
                DemoAlert("Default alert", CatAlertColor.Default)

                AlertDivider()

                AlertSectionHeader("Explicit trailing placement")
                AlertDivider()

                DemoAlert(
                    "Short heading",
                    CatAlertColor.Info,
                    buttonPlacement = CatAlertButtonPlacement.Trailing
                )
                DemoAlert(
                    "Short heading",
                    CatAlertColor.Success,
                    buttonPlacement = CatAlertButtonPlacement.Trailing
                )

                AlertDivider()

                AlertSectionHeader("Explicit below placement")
                AlertDivider()

                DemoAlert(
                    heading = "This is a longer heading that needs more than one line to display fully",
                    color = CatAlertColor.Info,
                    buttonPlacement = CatAlertButtonPlacement.Below,
                )
                DemoAlert(
                    heading = "This is a longer heading that needs more than one line to display fully",
                    color = CatAlertColor.Warning,
                    buttonPlacement = CatAlertButtonPlacement.Below,
                )
                DemoAlert(
                    heading = "This is a longer heading that needs more than one line to display fully",
                    color = CatAlertColor.Danger,
                    buttonPlacement = CatAlertButtonPlacement.Below,
                )

                AlertDivider()

                AlertSectionHeader("Disabled action")
                AlertDivider()

                DemoAlert(
                    heading = "Action is currently unavailable",
                    color = CatAlertColor.Info,
                    buttonEnabled = false,
                )
                DemoAlert(
                    heading = "This is a longer heading to test disabled with below placement",
                    color = CatAlertColor.Danger,
                    buttonPlacement = CatAlertButtonPlacement.Below,
                    buttonEnabled = false,
                )

                AlertDivider()

                AlertSectionHeader("Accessibility — iconContentDescription")
                AlertDivider()

                CatAlert(
                    heading = "With explicit icon description (TalkBack announces icon)",
                    color = CatAlertColor.Warning,
                    iconContentDescription = "Warning",
                )
                CatAlert(
                    heading = "No icon description (icon is decorative, heading carries meaning)",
                    color = CatAlertColor.Info,
                    iconContentDescription = null,
                )

                AlertDivider()

                AlertSectionHeader("Ambient config — ProvideCatAlertConfig")
                AlertDivider()

                ProvideCatAlertConfig(color = CatAlertColor.Danger) {
                    // Both alerts inherit Danger color from the ambient config
                    // without each needing an explicit color param.
                    CatAlert(heading = "Inherits Danger from ambient config")
                    CatAlert(heading = "Also inherits Danger from ambient config")
                    // Call-site override still wins:
                    CatAlert(
                        heading = "Overrides ambient to Success at call site",
                        color = CatAlertColor.Success,
                    )
                }

                AlertDivider()

                AlertSectionHeader("Optional action")
                AlertDivider()

                CatAlert(
                    heading = "Informational message",
                    leadingIcon = painterResource(R.drawable.info_circle_outlined),
                    color = CatAlertColor.Info,
                )
                CatAlert(
                    heading = "This is a longer informational message that wraps to multiple lines without an action",
                    leadingIcon = painterResource(R.drawable.icon_checkmark),
                    color = CatAlertColor.Success,
                )

                AlertDivider()

                AlertSectionHeader("Custom action slot")
                AlertDivider()

                CatAlert(
                    heading = "Text variant button",
                    leadingIcon = painterResource(R.drawable.info_circle_outlined),
                    color = CatAlertColor.Primary,
                    action = {
                        CatButton(
                            content = CatButtonContent.TextOnly("Learn more"),
                            onClick = {},
                            variant = CatButtonVariant.Text,
                            color = CatButtonColor.Primary,
                            size = CatButtonSize.Small,
                        )
                    },
                )
                CatAlert(
                    heading = "Icon + text button",
                    leadingIcon = painterResource(R.drawable.info_circle_outlined),
                    color = CatAlertColor.Warning,
                    buttonPlacement = CatAlertButtonPlacement.Below,
                    action = {
                        CatButton(
                            content = CatButtonContent.IconText(
                                painter = painterResource(id = R.drawable.icon_checkmark),
                                text = "Confirm",
                                placement = CatButtonPlacement.Leading,
                            ),
                            onClick = {},
                            variant = CatButtonVariant.Filled,
                            color = CatButtonColor.Success,
                            size = CatButtonSize.Medium,
                        )
                    },
                )
                CatAlert(
                    heading = "Link variant button",
                    leadingIcon = painterResource(R.drawable.info_circle_outlined),
                    color = CatAlertColor.Danger,
                    action = {
                        CatButton(
                            content = CatButtonContent.TextOnly("Dismiss"),
                            onClick = {},
                            variant = CatButtonVariant.Link,
                            color = CatButtonColor.Danger,
                        )
                    },
                )
            }
        }
    }
}

@Composable
private fun DemoAlert(
    heading: String,
    color: CatAlertColor,
    icon: Int = R.drawable.info_circle_outlined,
    buttonPlacement: CatAlertButtonPlacement = CatAlertButtonPlacement.Automatic,
    buttonEnabled: Boolean = true,
) {
    CatAlert(
        heading = heading,
        leadingIcon = painterResource(icon),
        color = color,
        buttonPlacement = buttonPlacement,
        action = {
            CatButton(
                content = CatButtonContent.TextOnly("Action"),
                onClick = {},
                variant = CatButtonVariant.Outlined,
                color = CatButtonColor.Secondary,
                enabled = buttonEnabled,
            )
        },
    )
}

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
