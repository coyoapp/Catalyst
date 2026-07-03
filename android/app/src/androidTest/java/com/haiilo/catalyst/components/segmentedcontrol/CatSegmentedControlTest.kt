package com.haiilo.catalyst.components.segmentedcontrol

import androidx.activity.ComponentActivity
import androidx.compose.ui.test.assertHasClickAction
import androidx.compose.ui.test.assertIsDisplayed
import androidx.compose.ui.test.assertIsNotEnabled
import androidx.compose.ui.test.assertIsNotSelected
import androidx.compose.ui.test.assertIsSelected
import androidx.compose.ui.test.hasClickAction
import androidx.compose.ui.test.hasText
import androidx.compose.ui.test.junit4.createAndroidComposeRule
import androidx.compose.ui.test.onNodeWithText
import androidx.compose.ui.test.performClick
import androidx.test.ext.junit.runners.AndroidJUnit4
import com.haiilo.catalyst.theme.CatTheme
import com.haiilo.catalystdemo.SegmentedControlDemoScreen
import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Rule
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(AndroidJUnit4::class)
class CatSegmentedControlTest {
    @get:Rule
    val composeRule = createAndroidComposeRule<ComponentActivity>()

    @Test
    fun twoOptionOverload_isDiscoverableViaSemantics_andSelectionChangesOnTap() {
        var selected: String? = "Option 1"

        composeRule.setContent {
            CatTheme {
                CatSegmentedControl(
                    firstItem = CatSegmentedControlItem("Option 1", CatSegmentedControlContent.TextOnly("Option 1")),
                    secondItem = CatSegmentedControlItem("Option 2", CatSegmentedControlContent.TextOnly("Option 2")),
                    selectedValue = selected,
                    onSelectionChange = { selected = it },
                )
            }
        }

        composeRule
            .onNodeWithText("Option 1")
            .assertIsDisplayed()
            .assertIsSelected()
            .assertHasClickAction()

        composeRule
            .onNodeWithText("Option 2")
            .assertIsDisplayed()
            .assertIsNotSelected()
            .performClick()

        composeRule.runOnIdle {
            assertEquals("Option 2", selected)
        }
    }

    @Test
    fun textSegments_areDiscoverableViaSemantics_andSelectionChangesOnTap() {
        var selected: String? = "Week"

        composeRule.setContent {
            CatTheme {
                CatSegmentedControl(
                    items = listOf(
                        CatSegmentedControlItem("Day", CatSegmentedControlContent.TextOnly("Day")),
                        CatSegmentedControlItem("Week", CatSegmentedControlContent.TextOnly("Week")),
                        CatSegmentedControlItem("Month", CatSegmentedControlContent.TextOnly("Month")),
                    ),
                    selectedValue = selected,
                    onSelectionChange = { selected = it },
                )
            }
        }

        composeRule
            .onNode(hasText("Week") and hasClickAction())
            .assertIsDisplayed()
            .assertHasClickAction()

        composeRule
            .onNode(hasText("Day") and hasClickAction())
            .assertIsDisplayed()
            .performClick()

        composeRule.runOnIdle {
            assertEquals("Day", selected)
        }
    }

    @Test
    fun disabledSegment_doesNotInvokeSelectionChange() {
        var selected = "Upcoming"
        var callbackInvoked = false

        composeRule.setContent {
            CatTheme {
                CatSegmentedControl(
                    items = listOf(
                        CatSegmentedControlItem("Upcoming", CatSegmentedControlContent.TextOnly("Upcoming")),
                        CatSegmentedControlItem(
                            value = "Archived",
                            content = CatSegmentedControlContent.TextOnly("Archived"),
                            enabled = false,
                        ),
                    ),
                    selectedValue = selected,
                    onSelectionChange = {
                        callbackInvoked = true
                        selected = it
                    },
                )
            }
        }

        composeRule
            .onNodeWithText("Archived")
            .assertIsDisplayed()
            .assertIsNotEnabled()

        composeRule.runOnIdle {
            assertEquals("Upcoming", selected)
            assertFalse(callbackInvoked)
        }
    }

    @Test
    fun demoScreen_rendersWithoutCrashing() {
        composeRule.setContent {
            SegmentedControlDemoScreen(onBack = {})
        }

        composeRule
            .onNodeWithText("Segmented Control")
            .assertIsDisplayed()

        composeRule
            .onNodeWithText("Design library like states")
            .assertIsDisplayed()
    }
}
