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
import com.haiilo.catalyst.components.segmentedcontrol.CatSegmentedControl
import com.haiilo.catalyst.components.segmentedcontrol.CatSegmentedControlColor
import com.haiilo.catalyst.components.segmentedcontrol.CatSegmentedControlContent
import com.haiilo.catalyst.components.segmentedcontrol.CatSegmentedControlItem
import com.haiilo.catalyst.theme.CatTheme
import com.haiilo.catalyst.theme.ProvideAccentColor
import com.haiilo.catalyst.tokens.generated.CatColors
import com.haiilo.catalyst.tokens.generated.CatSpacing
import com.haiilo.catalyst.tokens.generated.CatTypography

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

                Text("Segmented Control", style = CatTypography.h2)

                SegmentedSectionHeader("Design library like states")
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
        CatSegmentedControl(
            modifier = Modifier.fillMaxWidth(),
            firstItem = CatSegmentedControlItem("Option 1", CatSegmentedControlContent.TextOnly("Option 1")),
            secondItem = CatSegmentedControlItem("Option 2", CatSegmentedControlContent.TextOnly("Option 2")),
            selectedValue = topSelection,
            onSelectionChange = { topSelection = it },
            color = CatSegmentedControlColor.Primary,
        )

        CatSegmentedControl(
            modifier = Modifier.fillMaxWidth(),
            firstItem = CatSegmentedControlItem("Option 1", CatSegmentedControlContent.TextOnly("Option 1")),
            secondItem = CatSegmentedControlItem("Option 2", CatSegmentedControlContent.TextOnly("Option 2")),
            selectedValue = bottomSelection,
            onSelectionChange = { bottomSelection = it },
            color = CatSegmentedControlColor.Primary,
        )
    }
}

@Composable
private fun TypicalBinaryChoiceDemo() {
    var selectedValue by remember { mutableStateOf("Enabled") }

    CatSegmentedControl(
        modifier = Modifier.fillMaxWidth(),
        firstItem = CatSegmentedControlItem("Enabled", CatSegmentedControlContent.TextOnly("Enabled")),
        secondItem = CatSegmentedControlItem("Paused", CatSegmentedControlContent.TextOnly("Paused")),
        selectedValue = selectedValue,
        onSelectionChange = { selectedValue = it },
        color = CatSegmentedControlColor.Secondary,
    )
}

@Composable
private fun DisabledItemDemo() {
    var selectedValue by remember { mutableStateOf("Upcoming") }

    CatSegmentedControl(
        modifier = Modifier.fillMaxWidth(),
        firstItem = CatSegmentedControlItem("Upcoming", CatSegmentedControlContent.TextOnly("Upcoming")),
        secondItem = CatSegmentedControlItem(
            value = "Archived",
            content = CatSegmentedControlContent.TextOnly("Archived"),
            enabled = false,
        ),
        selectedValue = selectedValue,
        onSelectionChange = { selectedValue = it },
        color = CatSegmentedControlColor.Warning,
    )
}

@Composable
private fun AccentColorDemo() {
    var selectedValue by remember { mutableStateOf("Enabled") }

    CatSegmentedControl(
        modifier = Modifier.fillMaxWidth(),
        firstItem = CatSegmentedControlItem("Enabled", CatSegmentedControlContent.TextOnly("Enabled")),
        secondItem = CatSegmentedControlItem("Paused", CatSegmentedControlContent.TextOnly("Paused")),
        selectedValue = selectedValue,
        onSelectionChange = { selectedValue = it },
        color = CatSegmentedControlColor.Primary,
    )

    Box(
        modifier = Modifier
            .fillMaxWidth()
            .background(CatColors.Ui.Background.surface)
            .padding(CatSpacing.spacing_md),
    ) {
        ProvideAccentColor(Color(0xFFE8340A)) {
            CatSegmentedControl(
                modifier = Modifier.fillMaxWidth(),
                firstItem = CatSegmentedControlItem("Enabled", CatSegmentedControlContent.TextOnly("Enabled")),
                secondItem = CatSegmentedControlItem("Paused", CatSegmentedControlContent.TextOnly("Paused")),
                selectedValue = selectedValue,
                onSelectionChange = { selectedValue = it },
                color = CatSegmentedControlColor.Primary,
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
