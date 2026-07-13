package com.haiilo.catalystdemo

import androidx.compose.foundation.layout.Arrangement
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
import com.haiilo.catalyst.components.buttons.CatButton
import com.haiilo.catalyst.components.buttons.CatButtonColor
import com.haiilo.catalyst.components.buttons.CatButtonContent
import com.haiilo.catalyst.components.buttons.CatButtonVariant
import com.haiilo.catalyst.components.segmentedcontrol.CatSegmentedControl
import com.haiilo.catalyst.components.segmentedcontrol.CatSegmentedControlContent
import com.haiilo.catalyst.components.segmentedcontrol.CatSegmentedControlItem
import com.haiilo.catalyst.theme.CatTheme
import com.haiilo.catalyst.theme.ProvideAccentColor
import com.haiilo.catalyst.tokens.generated.CatSpacing
import com.haiilo.catalyst.tokens.generated.CatTypography
import androidx.compose.ui.graphics.Color

@Composable
fun SegmentedControlDemoScreen(onBack: () -> Unit) {
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

                SegmentedSectionHeader("Two segments")
                DesignLibraryDemo()

                SegmentedDivider()

                SegmentedSectionHeader("Three segments")
                TypicalBinaryChoiceDemo()

                SegmentedDivider()

                SegmentedSectionHeader("Accent color override")
                AccentColorDemo()

                SegmentedDivider()

                SegmentedSectionHeader("Disabled option")
                DisabledStateDemo()
            }
        }
    }
}

@Composable
private fun DesignLibraryDemo() {
    var selected by remember { mutableStateOf(0) }

    CatSegmentedControl(
        modifier = Modifier.fillMaxWidth(),
        segments = listOf("Option 1", "Option 2"),
        selection = selected,
        onSelectionChange = { selected = it },
    )
}

@Composable
private fun TypicalBinaryChoiceDemo() {
    var selected by remember { mutableStateOf(0) }

    CatSegmentedControl(
        modifier = Modifier.fillMaxWidth(),
        segments = listOf("Summarize", "Explain", "Translate"),
        selection = selected,
        onSelectionChange = { selected = it },
    )
}

@Composable
private fun AccentColorDemo() {
    var selected by remember { mutableStateOf(0) }

    ProvideAccentColor(Color(0xFFE8340A)) {
        CatSegmentedControl(
            modifier = Modifier.fillMaxWidth(),
            segments = listOf("Enabled", "Paused"),
            selection = selected,
            onSelectionChange = { selected = it },
        )
    }
}

@Composable
private fun DisabledStateDemo() {
    var selected by remember { mutableStateOf(0) }

    CatSegmentedControl(
        modifier = Modifier.fillMaxWidth(),
        items = listOf(
            CatSegmentedControlItem(
                value = "Upcoming",
                content = CatSegmentedControlContent.TextOnly("Upcoming"),
            ),
            CatSegmentedControlItem(
                value = "Archived",
                content = CatSegmentedControlContent.TextOnly("Archived"),
                enabled = false,
            ),
        ),
        selectedValue = if (selected == 0) "Upcoming" else "Archived",
        onSelectionChange = { selected = if (it == "Upcoming") 0 else 1 },
    )
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
