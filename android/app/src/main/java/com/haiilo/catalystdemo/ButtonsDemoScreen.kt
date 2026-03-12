package com.haiilo.catalystdemo

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.ExperimentalLayoutApi
import androidx.compose.foundation.layout.FlowRow
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.graphics.Color
import com.haiilo.catalyst.R
import com.haiilo.catalyst.components.buttons.CatButton
import com.haiilo.catalyst.components.buttons.CatButtonColor
import com.haiilo.catalyst.components.buttons.CatButtonContent
import com.haiilo.catalyst.components.buttons.CatButtonPlacement
import com.haiilo.catalyst.components.buttons.CatButtonSize
import com.haiilo.catalyst.components.buttons.CatButtonVariant
import com.haiilo.catalyst.components.buttons.ProvideCatButtonConfig
import com.haiilo.catalyst.theme.CatTheme
import com.haiilo.catalyst.theme.ProvideAccentColor
import com.haiilo.catalyst.tokens.generated.CatColors
import com.haiilo.catalyst.tokens.generated.CatSpacing
import com.haiilo.catalyst.tokens.generated.CatTypography

// ---------------------------------------------------------------------------
// ButtonsDemoScreen
//
// Demonstrates all CatButton variants, colors, sizes, content types,
// enabled/disabled states, full-width usage, and CompositionLocal injection.
// ---------------------------------------------------------------------------

@Composable
fun ButtonsDemoScreen(onBack: () -> Unit) {
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
                // Back navigation
                CatButton(
                    content = CatButtonContent.TextOnly("Back"),
                    onClick = onBack,
                    variant = CatButtonVariant.Text,
                    color = CatButtonColor.Primary,
                )

                Text("Buttons", style = CatTypography.h2)

                // ---------------------------------------------------------------
                // 1. Filled buttons — all colors
                // ---------------------------------------------------------------
                SectionHeader("Filled")
                ColorConfigRow(variant = CatButtonVariant.Filled)

                // ---------------------------------------------------------------
                // 2. Outlined buttons — all colors
                // ---------------------------------------------------------------
                SectionHeader("Outlined")
                ColorConfigRow(variant = CatButtonVariant.Outlined)

                // ---------------------------------------------------------------
                // 3. Text buttons — all colors
                // ---------------------------------------------------------------
                SectionHeader("Text")
                ColorConfigRow(variant = CatButtonVariant.Text)

                // ---------------------------------------------------------------
                // 4. Link buttons — all color configs
                // ---------------------------------------------------------------
                SectionHeader("Link")
                ColorConfigRow(variant = CatButtonVariant.Link)

                Divider()

                // ---------------------------------------------------------------
                // 5. Inverted — PrimaryInverted and SecondaryInverted
                //    Shown on a dark background so the light/inverted colors
                //    are visually meaningful (matches intended usage context).
                // ---------------------------------------------------------------
                SectionHeader("Inverted (on dark background)")
                Box(
                    modifier = Modifier
                        .fillMaxWidth()
                        .background(CatColors.Ui.Background.surfaceInverted)
                        .padding(CatSpacing.spacing_xl),
                ) {
                    Column(verticalArrangement = Arrangement.spacedBy(CatSpacing.spacing_md)) {
                        Text(
                            text = "PrimaryInverted",
                            style = CatTypography.s1,
                            color = CatColors.Ui.Font.bodyInverted,
                        )
                        ColorConfigRow(
                            variant = CatButtonVariant.Filled,
                            filter = { it == CatButtonColor.PrimaryInverted || it == CatButtonColor.SecondaryInverted },
                        )
                        ColorConfigRow(
                            variant = CatButtonVariant.Outlined,
                            filter = { it == CatButtonColor.PrimaryInverted || it == CatButtonColor.SecondaryInverted },
                        )
                        ColorConfigRow(
                            variant = CatButtonVariant.Text,
                            filter = { it == CatButtonColor.PrimaryInverted || it == CatButtonColor.SecondaryInverted },
                        )
                        ColorConfigRow(
                            variant = CatButtonVariant.Link,
                            filter = { it == CatButtonColor.PrimaryInverted || it == CatButtonColor.SecondaryInverted },
                        )
                    }
                }

                Divider()

                // ---------------------------------------------------------------
                // 5. Sizes — XSmall (32dp), Small (40dp), Medium (48dp)
                // ---------------------------------------------------------------
                SectionHeader("Sizes")
                Row(
                    horizontalArrangement = Arrangement.spacedBy(CatSpacing.spacing_md),
                    verticalAlignment = Alignment.CenterVertically,
                ) {
                    CatButton(
                        content = CatButtonContent.TextOnly("XSmall"),
                        onClick = {},
                        variant = CatButtonVariant.Filled,
                        color = CatButtonColor.Primary,
                        size = CatButtonSize.XSmall,
                    )
                    CatButton(
                        content = CatButtonContent.TextOnly("Small"),
                        onClick = {},
                        variant = CatButtonVariant.Filled,
                        color = CatButtonColor.Primary,
                        size = CatButtonSize.Small,
                    )
                    CatButton(
                        content = CatButtonContent.TextOnly("Medium"),
                        onClick = {},
                        variant = CatButtonVariant.Filled,
                        color = CatButtonColor.Primary,
                        size = CatButtonSize.Medium,
                    )
                }

                Divider()

                // ---------------------------------------------------------------
                // 6. Icon + Text — leading and trailing placement
                // ---------------------------------------------------------------
                SectionHeader("Icon + Text")
                Row(
                    horizontalArrangement = Arrangement.spacedBy(CatSpacing.spacing_md),
                    verticalAlignment = Alignment.CenterVertically,
                ) {
                    CatButton(
                        content = CatButtonContent.IconText(
                            painter = painterResource(id = R.drawable.icon_checkmark),
                            text = "Leading",
                            placement = CatButtonPlacement.Leading,
                        ),
                        onClick = {},
                        variant = CatButtonVariant.Filled,
                        color = CatButtonColor.Primary,
                    )
                    CatButton(
                        content = CatButtonContent.IconText(
                            painter = painterResource(id = R.drawable.icon_checkmark),
                            text = "Trailing",
                            placement = CatButtonPlacement.Trailing,
                        ),
                        onClick = {},
                        variant = CatButtonVariant.Outlined,
                        color = CatButtonColor.Primary,
                    )
                }
                Row(
                    horizontalArrangement = Arrangement.spacedBy(CatSpacing.spacing_md),
                    verticalAlignment = Alignment.CenterVertically,
                ) {
                    CatButton(
                        content = CatButtonContent.IconText(
                            painter = painterResource(id = R.drawable.icon_checkmark),
                            text = "Success",
                            placement = CatButtonPlacement.Leading,
                        ),
                        onClick = {},
                        variant = CatButtonVariant.Filled,
                        color = CatButtonColor.Success,
                    )
                    CatButton(
                        content = CatButtonContent.IconText(
                            painter = painterResource(id = R.drawable.icon_checkmark),
                            text = "Danger",
                            placement = CatButtonPlacement.Leading,
                        ),
                        onClick = {},
                        variant = CatButtonVariant.Filled,
                        color = CatButtonColor.Danger,
                    )
                }

                Divider()

                // ---------------------------------------------------------------
                // 7. Icon only
                // ---------------------------------------------------------------
                SectionHeader("Icon Only")
                Row(
                    horizontalArrangement = Arrangement.spacedBy(CatSpacing.spacing_md),
                    verticalAlignment = Alignment.CenterVertically,
                ) {
                    CatButton(
                        content = CatButtonContent.IconOnly(
                            painter = painterResource(id = R.drawable.icon_checkmark),
                            contentDescription = "Confirm",
                        ),
                        onClick = {},
                        variant = CatButtonVariant.Filled,
                        color = CatButtonColor.Primary,
                        size = CatButtonSize.Small,
                    )
                    CatButton(
                        content = CatButtonContent.IconOnly(
                            painter = painterResource(id = R.drawable.icon_checkmark),
                            contentDescription = "Confirm",
                        ),
                        onClick = {},
                        variant = CatButtonVariant.Outlined,
                        color = CatButtonColor.Danger,
                        size = CatButtonSize.Small,
                    )
                    CatButton(
                        content = CatButtonContent.IconOnly(
                            painter = painterResource(id = R.drawable.icon_checkmark),
                            contentDescription = "Confirm",
                        ),
                        onClick = {},
                        variant = CatButtonVariant.Text,
                        color = CatButtonColor.Success,
                        size = CatButtonSize.XSmall,
                    )
                }

                Divider()

                // ---------------------------------------------------------------
                // 8. Full width
                // ---------------------------------------------------------------
                SectionHeader("Full Width")
                CatButton(
                    content = CatButtonContent.TextOnly("Full Width — Primary Filled"),
                    onClick = {},
                    modifier = Modifier.fillMaxWidth(),
                    variant = CatButtonVariant.Filled,
                    color = CatButtonColor.Primary,
                )
                CatButton(
                    content = CatButtonContent.IconText(
                        painter = painterResource(id = R.drawable.icon_checkmark),
                        text = "Full Width — Danger Outlined",
                        placement = CatButtonPlacement.Leading,
                    ),
                    onClick = {},
                    modifier = Modifier.fillMaxWidth(),
                    variant = CatButtonVariant.Outlined,
                    color = CatButtonColor.Danger,
                )
                CatButton(
                    content = CatButtonContent.TextOnly("Full Width — Success Text"),
                    onClick = {},
                    modifier = Modifier.fillMaxWidth(),
                    variant = CatButtonVariant.Text,
                    color = CatButtonColor.Success,
                )

                Divider()

                // ---------------------------------------------------------------
                // 9. Disabled states — one per variant
                // ---------------------------------------------------------------
                SectionHeader("Disabled")
                Row(
                    horizontalArrangement = Arrangement.spacedBy(CatSpacing.spacing_md),
                    verticalAlignment = Alignment.CenterVertically,
                ) {
                    CatButton(
                        content = CatButtonContent.TextOnly("Filled"),
                        onClick = {},
                        variant = CatButtonVariant.Filled,
                        color = CatButtonColor.Primary,
                        enabled = false,
                    )
                    CatButton(
                        content = CatButtonContent.TextOnly("Outlined"),
                        onClick = {},
                        variant = CatButtonVariant.Outlined,
                        color = CatButtonColor.Primary,
                        enabled = false,
                    )
                    CatButton(
                        content = CatButtonContent.TextOnly("Text"),
                        onClick = {},
                        variant = CatButtonVariant.Text,
                        color = CatButtonColor.Primary,
                        enabled = false,
                    )
                    CatButton(
                        content = CatButtonContent.TextOnly("Link"),
                        onClick = {},
                        variant = CatButtonVariant.Link,
                        color = CatButtonColor.Primary,
                        enabled = false,
                    )
                }

                Divider()

                // ---------------------------------------------------------------
                // 10. CompositionLocal demo — ProvideCatButtonConfig
                // ---------------------------------------------------------------
                SectionHeader("ProvideCatButtonConfig")
                Text(
                    text = "All buttons inside the provider inherit Outlined + Warning without explicit params.",
                    style = CatTypography.body2,
                )
                Spacer(modifier = Modifier.height(CatSpacing.spacing_md))
                ProvideCatButtonConfig(
                    variant = CatButtonVariant.Outlined,
                    color = CatButtonColor.Warning,
                ) {
                    Row(
                        horizontalArrangement = Arrangement.spacedBy(CatSpacing.spacing_md),
                        verticalAlignment = Alignment.CenterVertically,
                    ) {
                        // No explicit variant/color — inherits from CompositionLocal
                        CatButton(content = CatButtonContent.TextOnly("Button A"), onClick = {})
                        CatButton(content = CatButtonContent.TextOnly("Button B"), onClick = {})
                        // Override just the color at call site
                        CatButton(
                            content = CatButtonContent.TextOnly("Override"),
                            onClick = {},
                            color = CatButtonColor.Info,
                        )
                    }
                }

                Divider()

                // ---------------------------------------------------------------
                // 11. Accent color (whitelabel) — ProvideAccentColor per-subtree
                //     The app-wide accent (#1A73E8) is set in MainActivity via
                //     CatThemeConfig.configure(). ProvideAccentColor overrides it
                //     for a specific subtree.
                // ---------------------------------------------------------------
                SectionHeader("Accent Color (Whitelabel)")
                Text(
                    text = "App-wide accent (#1A73E8) is set in MainActivity.onCreate() via CatThemeConfig.configure(). " +
                        "ProvideAccentColor overrides it per-subtree.",
                    style = CatTypography.body2,
                )
                Spacer(modifier = Modifier.height(CatSpacing.spacing_md))
                Text("App-wide accent (from CatThemeConfig):", style = CatTypography.s1)
                Row(
                    horizontalArrangement = Arrangement.spacedBy(CatSpacing.spacing_md),
                    verticalAlignment = Alignment.CenterVertically,
                ) {
                    CatButton(
                        content = CatButtonContent.TextOnly("Filled"),
                        onClick = {},
                        variant = CatButtonVariant.Filled,
                        color = CatButtonColor.Primary,
                    )
                    CatButton(
                        content = CatButtonContent.TextOnly("Outlined"),
                        onClick = {},
                        variant = CatButtonVariant.Outlined,
                        color = CatButtonColor.Primary,
                    )
                    CatButton(
                        content = CatButtonContent.TextOnly("Text"),
                        onClick = {},
                        variant = CatButtonVariant.Text,
                        color = CatButtonColor.Primary,
                    )
                }
                Spacer(modifier = Modifier.height(CatSpacing.spacing_md))
                Text("Per-subtree override (#E8340A — red):", style = CatTypography.s1)
                ProvideAccentColor(Color(0xFFE8340A)) {
                    Row(
                        horizontalArrangement = Arrangement.spacedBy(CatSpacing.spacing_md),
                        verticalAlignment = Alignment.CenterVertically,
                    ) {
                        CatButton(
                            content = CatButtonContent.TextOnly("Filled"),
                            onClick = {},
                            variant = CatButtonVariant.Filled,
                            color = CatButtonColor.Primary,
                        )
                        CatButton(
                            content = CatButtonContent.TextOnly("Outlined"),
                            onClick = {},
                            variant = CatButtonVariant.Outlined,
                            color = CatButtonColor.Primary,
                        )
                        CatButton(
                            content = CatButtonContent.TextOnly("Text"),
                            onClick = {},
                            variant = CatButtonVariant.Text,
                            color = CatButtonColor.Primary,
                        )
                    }
                }

                Spacer(modifier = Modifier.height(CatSpacing.spacing_4xl))
            }
        }
    }
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

@OptIn(ExperimentalLayoutApi::class)
@Composable
private fun ColorConfigRow(
    variant: CatButtonVariant,
    filter: (CatButtonColor) -> Boolean = { true },
) {
    FlowRow(
        horizontalArrangement = Arrangement.spacedBy(CatSpacing.spacing_md),
        verticalArrangement = Arrangement.spacedBy(CatSpacing.spacing_md),
    ) {
        CatButtonColor.entries.filter(filter).forEach { color ->
            CatButton(
                content = CatButtonContent.TextOnly(color.name),
                onClick = {},
                variant = variant,
                color = color,
            )
        }
    }
}

@Composable
private fun SectionHeader(title: String) {
    Text(title, style = CatTypography.s1)
}

@Composable
private fun Divider() {
    HorizontalDivider(
        modifier = Modifier.padding(vertical = CatSpacing.spacing_md),
    )
}
