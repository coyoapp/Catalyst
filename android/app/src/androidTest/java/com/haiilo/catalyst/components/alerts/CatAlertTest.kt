package com.haiilo.catalyst.components.alerts

import androidx.activity.ComponentActivity
import androidx.compose.foundation.layout.width
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.test.assertHasClickAction
import androidx.compose.ui.test.assertIsDisplayed
import androidx.compose.ui.test.assertIsNotEnabled
import androidx.compose.ui.test.junit4.createAndroidComposeRule
import androidx.compose.ui.test.onAllNodesWithText
import androidx.compose.ui.test.onNodeWithContentDescription
import androidx.compose.ui.test.onNodeWithText
import androidx.compose.ui.test.performClick
import androidx.compose.ui.unit.dp
import androidx.test.ext.junit.runners.AndroidJUnit4
import com.haiilo.catalyst.R
import com.haiilo.catalyst.components.buttons.CatButton
import com.haiilo.catalyst.components.buttons.CatButtonColor
import com.haiilo.catalyst.components.buttons.CatButtonContent
import com.haiilo.catalyst.components.buttons.CatButtonSize
import com.haiilo.catalyst.components.buttons.CatButtonVariant
import com.haiilo.catalyst.theme.CatTheme
import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.Rule
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(AndroidJUnit4::class)
class CatAlertTest {

    @get:Rule
    val composeRule = createAndroidComposeRule<ComponentActivity>()

    @Test
    fun alertAndAction_areDiscoverableViaSemantics_withoutTestTags() {
        var clicks = 0

        composeRule.setContent {
            CatTheme {
                CatAlert(
                    heading = "Connection issue",
                    iconContentDescription = "Alert status",
                    action = {
                        CatButton(
                            content = CatButtonContent.TextOnly("Retry"),
                            onClick = { clicks++ },
                            variant = CatButtonVariant.Outlined,
                            color = CatButtonColor.Secondary,
                        )
                    },
                )
            }
        }

        composeRule.onNodeWithText("Connection issue").assertIsDisplayed()
        composeRule.onNodeWithContentDescription("Alert status").assertIsDisplayed()

        composeRule.onNodeWithText("Retry")
            .assertIsDisplayed()
            .assertHasClickAction()
            .performClick()

        composeRule.runOnIdle {
            assertEquals(1, clicks)
        }
    }

    @Test
    fun action_clickInvokesCallback() {
        var clicks = 0

        composeRule.setContent {
            CatTheme {
                CatAlert(
                    heading = "Network issue",
                    action = {
                        CatButton(
                            content = CatButtonContent.TextOnly("Retry"),
                            onClick = { clicks++ },
                            variant = CatButtonVariant.Outlined,
                            color = CatButtonColor.Secondary,
                        )
                    },
                )
            }
        }

        composeRule.onNodeWithText("Retry")
            .assertIsDisplayed()
            .assertHasClickAction()
            .performClick()

        composeRule.runOnIdle {
            assertEquals(1, clicks)
        }
    }

    @Test
    fun noAction_showsHeadingAndLeadingIconOnly() {
        composeRule.setContent {
            CatTheme {
                CatAlert(
                    heading = "Informational alert without action",
                    iconContentDescription = "Alert icon",
                )
            }
        }

        composeRule.onNodeWithText("Informational alert without action")
            .assertIsDisplayed()
        composeRule.onNodeWithContentDescription("Alert icon")
            .assertIsDisplayed()

        assertTrue(
            composeRule.onAllNodesWithText("Retry")
                .fetchSemanticsNodes(atLeastOneRootRequired = false)
                .isEmpty(),
        )
    }

    @Test
    fun customAction_belowPlacement_rendersAndClicks() {
        var clicks = 0

        composeRule.setContent {
            CatTheme {
                CatAlert(
                    heading = "Update available",
                    buttonPlacement = CatAlertButtonPlacement.Below,
                    action = {
                        CatButton(
                            content = CatButtonContent.IconText(
                                painter = painterResource(id = R.drawable.info_circle_outlined),
                                text = "Learn more",
                            ),
                            onClick = { clicks++ },
                            variant = CatButtonVariant.Text,
                            color = CatButtonColor.Info,
                            size = CatButtonSize.Medium,
                        )
                    },
                )
            }
        }

        composeRule.onNodeWithText("Learn more")
            .assertIsDisplayed()
            .assertHasClickAction()
            .performClick()

        composeRule.runOnIdle {
            assertEquals(1, clicks)
        }
    }

    @Test
    fun customAction_canBeDisabled() {
        var clicked = false

        composeRule.setContent {
            CatTheme {
                CatAlert(
                    heading = "Action unavailable",
                    action = {
                        CatButton(
                            content = CatButtonContent.TextOnly("Retry"),
                            onClick = { clicked = true },
                            variant = CatButtonVariant.Outlined,
                            color = CatButtonColor.Secondary,
                            enabled = false,
                        )
                    },
                )
            }
        }

        composeRule.onNodeWithText("Retry")
            .assertIsDisplayed()
            .assertIsNotEnabled()

        composeRule.runOnIdle {
            assertFalse(clicked)
        }
    }

    @Test
    fun automaticPlacement_shortHeading_keepsActionTrailing() {
        composeRule.setContent {
            CatTheme {
                CatAlert(
                    modifier = Modifier.width(360.dp),
                    heading = "Saved",
                    buttonPlacement = CatAlertButtonPlacement.Automatic,
                    action = {
                        CatButton(
                            content = CatButtonContent.TextOnly("Undo"),
                            onClick = {},
                            variant = CatButtonVariant.Outlined,
                            color = CatButtonColor.Secondary,
                        )
                    },
                )
            }
        }

        val headingBounds = composeRule.onAllNodesWithText("Saved")
            .fetchSemanticsNodes()
            .first()
            .boundsInRoot
        val actionBounds = composeRule.onAllNodesWithText("Undo")
            .fetchSemanticsNodes()
            .first()
            .boundsInRoot

        assertTrue(actionBounds.top < headingBounds.bottom)
    }

    @Test
    fun automaticPlacement_longHeading_movesActionBelow() {
        composeRule.setContent {
            CatTheme {
                CatAlert(
                    modifier = Modifier.width(240.dp),
                    heading = "This is a very long alert heading that should force the action below",
                    buttonPlacement = CatAlertButtonPlacement.Automatic,
                    action = {
                        CatButton(
                            content = CatButtonContent.TextOnly("Undo"),
                            onClick = {},
                            variant = CatButtonVariant.Outlined,
                            color = CatButtonColor.Secondary,
                        )
                    },
                )
            }
        }

        val headingBounds = composeRule
            .onAllNodesWithText(
                "This is a very long alert heading that should force the action below",
                substring = true
            )
            .fetchSemanticsNodes()
            .first()
            .boundsInRoot
        val actionBounds = composeRule.onAllNodesWithText("Undo")
            .fetchSemanticsNodes()
            .first()
            .boundsInRoot

        assertTrue(actionBounds.top >= headingBounds.bottom)
    }
}

