package com.haiilo.catalystdemo

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.HorizontalDivider
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
import com.haiilo.catalyst.components.buttons.CatButton
import com.haiilo.catalyst.components.buttons.CatButtonColor
import com.haiilo.catalyst.components.buttons.CatButtonContent
import com.haiilo.catalyst.components.buttons.CatButtonVariant
import com.haiilo.catalyst.components.segmentedtoggle.CatSegmentedToggle
import com.haiilo.catalyst.components.segmentedtoggle.CatSegmentedToggleColor
import com.haiilo.catalyst.components.segmentedtoggle.CatSegmentedToggleContent
import com.haiilo.catalyst.components.segmentedtoggle.CatSegmentedToggleItem
import com.haiilo.catalyst.theme.CatTheme
import com.haiilo.catalyst.theme.ProvideAccentColor
import com.haiilo.catalyst.tokens.generated.CatColors
import com.haiilo.catalyst.tokens.generated.CatSpacing
import com.haiilo.catalyst.tokens.generated.CatTypography

@Composable
fun SegmentedToggleDemoScreen(onBack: () -> Unit) {
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

                Text("Segmented Toggle", style = CatTypography.h2)

                Text(
                    text = "V1 recommendation: use segmented toggle primarily as a 2-option, full-width, text-only selector.",
                    style = CatTypography.body2,
                )

                SegmentedSectionHeader("Screenshot-like states")
                DesignLibraryDemo()

                SegmentedDivider()

                SegmentedSectionHeader("Typical binary choice")
                TypicalBinaryChoiceDemo()

                SegmentedDivider()

                SegmentedSectionHeader("Disabled option")
                DisabledItemDemo()

                SegmentedDivider()

                SegmentedSectionHeader("Accent color override")
                AccentColorDemo()
            }
        }
    }
}

@Composable
private fun DesignLibraryDemo() {
    var topSelection by remember { mutableStateOf("Option 1") }
    var bottomSelection by remember { mutableStateOf("Option 2") }

    Column(verticalArrangement = Arrangement.spacedBy(CatSpacing.spacing_xl)) {
        CatSegmentedToggle(
            modifier = Modifier.fillMaxWidth(),
            firstItem = CatSegmentedToggleItem("Option 1", CatSegmentedToggleContent.TextOnly("Option 1")),
            secondItem = CatSegmentedToggleItem("Option 2", CatSegmentedToggleContent.TextOnly("Option 2")),
            selectedValue = topSelection,
            onSelectionChange = { topSelection = it },
            color = CatSegmentedToggleColor.Primary,
        )

        CatSegmentedToggle(
            modifier = Modifier.fillMaxWidth(),
            firstItem = CatSegmentedToggleItem("Option 1", CatSegmentedToggleContent.TextOnly("Option 1")),
            secondItem = CatSegmentedToggleItem("Option 2", CatSegmentedToggleContent.TextOnly("Option 2")),
            selectedValue = bottomSelection,
            onSelectionChange = { bottomSelection = it },
            color = CatSegmentedToggleColor.Primary,
        )
    }
}

@Composable
private fun TypicalBinaryChoiceDemo() {
    var selectedValue by remember { mutableStateOf("Enabled") }

    CatSegmentedToggle(
        modifier = Modifier.fillMaxWidth(),
        firstItem = CatSegmentedToggleItem("Enabled", CatSegmentedToggleContent.TextOnly("Enabled")),
        secondItem = CatSegmentedToggleItem("Paused", CatSegmentedToggleContent.TextOnly("Paused")),
        selectedValue = selectedValue,
        onSelectionChange = { selectedValue = it },
        color = CatSegmentedToggleColor.Secondary,
    )

    Text(
        text = "Selected: $selectedValue",
        style = CatTypography.body2,
    )
}

@Composable
private fun DisabledItemDemo() {
    var selectedValue by remember { mutableStateOf("Upcoming") }

    CatSegmentedToggle(
        modifier = Modifier.fillMaxWidth(),
        firstItem = CatSegmentedToggleItem("Upcoming", CatSegmentedToggleContent.TextOnly("Upcoming")),
        secondItem = CatSegmentedToggleItem(
            value = "Archived",
            content = CatSegmentedToggleContent.TextOnly("Archived"),
            enabled = false,
        ),
        selectedValue = selectedValue,
        onSelectionChange = { selectedValue = it },
        color = CatSegmentedToggleColor.Warning,
    )
}

@Composable
private fun AccentColorDemo() {
    var selectedValue by remember { mutableStateOf("Enabled") }

    Text(
        text = "App-wide accent uses the color configured in CatThemeConfig. The subtree below overrides it to red.",
        style = CatTypography.body2,
    )

    CatSegmentedToggle(
        modifier = Modifier.fillMaxWidth(),
        firstItem = CatSegmentedToggleItem("Enabled", CatSegmentedToggleContent.TextOnly("Enabled")),
        secondItem = CatSegmentedToggleItem("Paused", CatSegmentedToggleContent.TextOnly("Paused")),
        selectedValue = selectedValue,
        onSelectionChange = { selectedValue = it },
        color = CatSegmentedToggleColor.Primary,
    )

    Box(
        modifier = Modifier
            .fillMaxWidth()
            .background(CatColors.Ui.Background.surface)
            .padding(CatSpacing.spacing_md),
    ) {
        ProvideAccentColor(Color(0xFFE8340A)) {
            CatSegmentedToggle(
                modifier = Modifier.fillMaxWidth(),
                firstItem = CatSegmentedToggleItem("Enabled", CatSegmentedToggleContent.TextOnly("Enabled")),
                secondItem = CatSegmentedToggleItem("Paused", CatSegmentedToggleContent.TextOnly("Paused")),
                selectedValue = selectedValue,
                onSelectionChange = { selectedValue = it },
                color = CatSegmentedToggleColor.Primary,
            )
        }
    }
}

@Composable
private fun SegmentedSectionHeader(title: String) {
    Text(title, style = CatTypography.s1)
}

@Composable
private fun SegmentedDivider() {
    HorizontalDivider(
        modifier = Modifier.padding(vertical = CatSpacing.spacing_md),
    )
}
