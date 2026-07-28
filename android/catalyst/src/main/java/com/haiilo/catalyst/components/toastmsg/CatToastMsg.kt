// CatToastMsg.kt
// Catalyst
//
// Created by Catalyst Agent on 2026-07-21.
//
// Display profile — Box + clip + background layout. No Material3 Surface.
// Reference: CatAlert.kt

package com.haiilo.catalyst.components.toastmsg

import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.interaction.MutableInteractionSource
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.material3.ripple
import androidx.compose.runtime.Composable
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.painter.Painter
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.semantics.Role
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import com.haiilo.catalyst.R
import com.haiilo.catalyst.theme.LocalCatAccentPalette
import com.haiilo.catalyst.tokens.generated.CatBorderRadius
import com.haiilo.catalyst.tokens.generated.CatSizes
import com.haiilo.catalyst.tokens.generated.CatSpacing
import com.haiilo.catalyst.tokens.generated.CatTypography

// ---------------------------------------------------------------------------
// CatToastMsg
//
// A floating toast notification that appears at the bottom of the screen.
// The surface is display-only; the optional action slot and the internal
// dismiss button are the only interactive elements.
//
// Layout variants:
//   - Compact:  Single-row, 56 dp tall. Icon + title + action? + dismiss?.
//   - Expanded: Stacked. Title wraps freely; action below title; dismiss top-end.
//
// Fixed width: 343 dp per design spec. Always dark surface + inverted text.
// Action text color uses primaryInverted.text, accent-overridable for whitelabeling.
//
// Configuration priority (highest → lowest):
//   1. Explicit [colors]
//   2. Explicit [variant]
//   3. [LocalCatToastMsgConfig]
//   4. Defaults: Compact
// ---------------------------------------------------------------------------

private val ToastFixedWidth = 343.dp
private val ToastCompactHeight = 56.dp

/**
 * Catalyst toast message component.
 *
 * @param title             The toast's message text.
 * @param modifier          Applied to the outer container.
 * @param variant           Layout mode override. Null reads from [LocalCatToastMsgConfig].
 * @param leadingIcon       Optional leading status icon painter. Null hides the icon slot.
 * @param showDismissButton When true (default), an internal × dismiss button is shown.
 * @param onDismiss         Called when the dismiss button is tapped.
 *                          Null means no-op when [showDismissButton] is true.
 * @param colors            Full color override. When non-null, tokens are ignored for styling.
 * @param testTag           Tag used by UI automation tests to locate this toast. Null skips tagging.
 *                          The internal dismiss button always carries the fixed tag
 *                          `"toast.msg.cross.dismissbutton"`.
 * @param action            Optional action slot, typically a [com.haiilo.catalyst.components.buttons.CatButton].
 *                          The consumer is responsible for applying the correct text/tint color
 *                          from [CatToastMsgColors.actionColor] if using a raw composable.
 */
@Composable
fun CatToastMsg(
    title: String,
    modifier: Modifier = Modifier,
    variant: CatToastMsgVariant? = null,
    leadingIcon: Painter? = null,
    showDismissButton: Boolean = true,
    onDismiss: (() -> Unit)? = null,
    colors: CatToastMsgColors? = null,
    testTag: String? = null,
    action: (@Composable () -> Unit)? = null,
) {
    val ambientConfig = LocalCatToastMsgConfig.current
    val resolvedVariant = variant ?: ambientConfig.variant
    val accentPalette = LocalCatAccentPalette.current
    val resolvedColors = colors ?: CatToastMsgDefaults.colors(accentPalette)

    val shape = RoundedCornerShape(CatBorderRadius.border_radius_lg)

    Box(
        modifier = modifier
            .width(ToastFixedWidth)
            .then(if (testTag != null) Modifier.testTag(testTag) else Modifier)
            .clip(shape)
            .background(color = resolvedColors.background, shape = shape),
    ) {
        when (resolvedVariant) {
            CatToastMsgVariant.Compact -> CompactLayout(
                title = title,
                leadingIcon = leadingIcon,
                showDismissButton = showDismissButton,
                onDismiss = onDismiss,
                colors = resolvedColors,
                action = action,
            )
            CatToastMsgVariant.Expanded -> ExpandedLayout(
                title = title,
                leadingIcon = leadingIcon,
                showDismissButton = showDismissButton,
                onDismiss = onDismiss,
                colors = resolvedColors,
                action = action,
            )
        }
    }
}

// ---------------------------------------------------------------------------
// CompactLayout — single row, fixed 56 dp height
// ---------------------------------------------------------------------------

@Composable
private fun CompactLayout(
    title: String,
    leadingIcon: Painter?,
    showDismissButton: Boolean,
    onDismiss: (() -> Unit)?,
    colors: CatToastMsgColors,
    action: (@Composable () -> Unit)?,
) {
    Row(
        modifier = Modifier
            .height(ToastCompactHeight)
            .padding(horizontal = CatSpacing.spacing_xl),
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(CatSpacing.spacing_lg),
    ) {
        if (leadingIcon != null) {
            Icon(
                painter = leadingIcon,
                contentDescription = null,
                modifier = Modifier.size(CatSizes.size_md),
                tint = colors.foreground,
            )
        }

        Text(
            text = title,
            style = CatTypography.s1,
            color = colors.foreground,
            maxLines = 1,
            overflow = TextOverflow.Ellipsis,
            modifier = Modifier.weight(1f),
        )

        if (action != null) {
            // The action slot is typically a CatButton. The consumer should configure
            // the button's color via .catButtonConfig or pass colors.actionColor explicitly.
            action()
        }

        if (showDismissButton) {
            DismissButton(onDismiss = onDismiss, tint = colors.foreground)
        }
    }
}

// ---------------------------------------------------------------------------
// ExpandedLayout — stacked, dismiss anchored top-end
// ---------------------------------------------------------------------------

@Composable
private fun ExpandedLayout(
    title: String,
    leadingIcon: Painter?,
    showDismissButton: Boolean,
    onDismiss: (() -> Unit)?,
    colors: CatToastMsgColors,
    action: (@Composable () -> Unit)?,
) {
    Row(
        modifier = Modifier
            .padding(horizontal = CatSpacing.spacing_xl, vertical = CatSpacing.spacing_xl),
        verticalAlignment = Alignment.Top,
    ) {
        if (leadingIcon != null) {
            Icon(
                painter = leadingIcon,
                contentDescription = null,
                modifier = Modifier
                    .size(CatSizes.size_md)
                    .padding(top = CatSpacing.spacing_xs),
                tint = colors.foreground,
            )
            Spacer(Modifier.width(CatSpacing.spacing_lg))
        }

        Column(
            modifier = Modifier.weight(1f),
        ) {
            Text(
                text = title,
                style = CatTypography.s1,
                color = colors.foreground,
                overflow = TextOverflow.Clip,
            )
            if (action != null) {
                Spacer(Modifier.height(CatSpacing.spacing_md))
                action()
            }
        }

        if (showDismissButton) {
            Spacer(Modifier.width(CatSpacing.spacing_lg))
            DismissButton(onDismiss = onDismiss, tint = colors.foreground)
        }
    }
}

// ---------------------------------------------------------------------------
// DismissButton — internal × close button
// ---------------------------------------------------------------------------

@Composable
private fun DismissButton(
    onDismiss: (() -> Unit)?,
    tint: androidx.compose.ui.graphics.Color,
) {
    val interactionSource = remember { MutableInteractionSource() }
    Icon(
        painter = painterResource(id = R.drawable.ic_cross_outlined_25),
        contentDescription = null,
        modifier = Modifier
            .size(CatSizes.size_md)
            .testTag("toast.msg.cross.dismissbutton")
            .clickable(
                interactionSource = interactionSource,
                indication = ripple(bounded = false, color = tint.copy(alpha = 0.12f)),
                role = Role.Button,
                onClick = { onDismiss?.invoke() },
            ),
        tint = tint,
    )
}
