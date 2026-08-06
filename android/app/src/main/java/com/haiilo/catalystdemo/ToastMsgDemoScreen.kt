package com.haiilo.catalystdemo

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.painterResource
import com.haiilo.catalyst.R
import com.haiilo.catalyst.components.buttons.CatButton
import com.haiilo.catalyst.components.buttons.CatButtonColor
import com.haiilo.catalyst.components.buttons.CatButtonContent
import com.haiilo.catalyst.components.buttons.CatButtonSize
import com.haiilo.catalyst.components.buttons.CatButtonVariant
import com.haiilo.catalyst.components.toastmsg.CatToastMsg
import com.haiilo.catalyst.components.toastmsg.CatToastMsgVariant
import com.haiilo.catalyst.theme.CatTheme
import com.haiilo.catalyst.tokens.generated.CatSpacing
import com.haiilo.catalyst.tokens.generated.CatTypography

@Composable
fun ToastMsgDemoScreen(onBack: () -> Unit) {
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

                Text("Toast Msg", style = CatTypography.h2)

                // 1. Compact — no icon, no dismiss
                CatToastMsg(
                    title = "Hello World",
                    showDismissButton = false,
                )

                // 2. Compact — icon, no dismiss
                CatToastMsg(
                    title = "Toast with Icon",
                    leadingIcon = painterResource(R.drawable.ic_check_circle_outlined_24),
                    showDismissButton = false,
                )

                // 3. Compact — icon + CatButton action, no dismiss
                CatToastMsg(
                    title = "Toast with CatButton",
                    leadingIcon = painterResource(R.drawable.ic_check_circle_outlined_24),
                    showDismissButton = false,
                    action = {
                        CatButton(
                            content = CatButtonContent.TextOnly("Dismiss"),
                            onClick = {},
                            variant = CatButtonVariant.Text,
                            color = CatButtonColor.PrimaryInverted,
                            size = CatButtonSize.XSmall,
                        )
                    },
                )

                // 4. Compact — icon + CatButton action + dismiss
                CatToastMsg(
                    title = "Toast with CatButton",
                    leadingIcon = painterResource(R.drawable.ic_info_outlined_25),
                    showDismissButton = true,
                    onDismiss = {},
                    action = {
                        CatButton(
                            content = CatButtonContent.TextOnly("Dismiss"),
                            onClick = {},
                            variant = CatButtonVariant.Text,
                            color = CatButtonColor.PrimaryInverted,
                            size = CatButtonSize.XSmall,
                        )
                    },
                )

                // 5. Compact — icon + CatButton action + dismiss (same as 4, iOS diff was zero padding only)
                CatToastMsg(
                    title = "Toast with CatButton",
                    leadingIcon = painterResource(R.drawable.ic_info_outlined_25),
                    showDismissButton = true,
                    onDismiss = {},
                    action = {
                        CatButton(
                            content = CatButtonContent.TextOnly("Dismiss"),
                            onClick = {},
                            variant = CatButtonVariant.Text,
                            color = CatButtonColor.PrimaryInverted,
                            size = CatButtonSize.XSmall,
                        )
                    },
                )

                // 6. Expanded — icon + CatButton text action + dismiss
                CatToastMsg(
                    title = "Toast with CatButton",
                    variant = CatToastMsgVariant.Expanded,
                    leadingIcon = painterResource(R.drawable.ic_info_outlined_25),
                    showDismissButton = true,
                    onDismiss = {},
                    action = {
                        CatButton(
                            content = CatButtonContent.TextOnly("Dismiss"),
                            onClick = {},
                            variant = CatButtonVariant.Text,
                            color = CatButtonColor.PrimaryInverted,
                            size = CatButtonSize.XSmall,
                        )
                    },
                )

                // 7. Expanded — icon + CatButton outlined action + dismiss
                CatToastMsg(
                    title = "Toast with CatButton",
                    variant = CatToastMsgVariant.Expanded,
                    leadingIcon = painterResource(R.drawable.ic_info_outlined_25),
                    showDismissButton = true,
                    onDismiss = {},
                    action = {
                        CatButton(
                            content = CatButtonContent.TextOnly("Dismiss"),
                            onClick = {},
                            variant = CatButtonVariant.Outlined,
                            color = CatButtonColor.PrimaryInverted,
                            size = CatButtonSize.XSmall,
                        )
                    },
                )

                // 8. Expanded — icon + plain Material3 TextButton + dismiss
                CatToastMsg(
                    title = "Toast with Button",
                    variant = CatToastMsgVariant.Expanded,
                    leadingIcon = painterResource(R.drawable.ic_info_outlined_25),
                    showDismissButton = true,
                    onDismiss = {},
                    action = {
                        TextButton(onClick = {}) {
                            Text("Action")
                        }
                    },
                )
            }
        }
    }
}
