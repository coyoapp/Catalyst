package com.haiilo.catalyst.components.segmentedcontrol

import androidx.activity.ComponentActivity
import androidx.compose.ui.test.assertHasClickAction
import androidx.compose.ui.test.assertIsDisplayed
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
    fun textSegments_areDiscoverableViaSemantics_andSelectionChangesOnTap() {
        var selected = 0

        composeRule.setContent {
            CatTheme {
                CatSegmentedControl(
                    segments = listOf("Option 1", "Option 2"),
                    selection = selected,
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
            assertEquals(1, selected)
        }
    }

    @Test
    fun threeSegments_canChangeSelection() {
        var selected = 1

        composeRule.setContent {
            CatTheme {
                CatSegmentedControl(
                    segments = listOf("Day", "Week", "Month"),
                    selection = selected,
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
            assertEquals(0, selected)
        }
    }

    @Test
    fun selectingAlreadySelectedSegment_keepsSelection() {
        var selected = 0
        var callbackInvoked = false

        composeRule.setContent {
            CatTheme {
                CatSegmentedControl(
                    segments = listOf("Upcoming", "Archived"),
                    selection = selected,
                    onSelectionChange = {
                        callbackInvoked = true
                        selected = it
                    },
                )
            }
        }

        composeRule
            .onNodeWithText("Upcoming")
            .assertIsDisplayed()
            .assertIsSelected()
            .performClick()

        composeRule.runOnIdle {
            assertEquals(0, selected)
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
            .onNodeWithText("Two segments")
            .assertIsDisplayed()
    }
}
