//
//  CatTheme+List.swift
//  Catalyst
//
//  Created by Efe Durmaz on 04.05.26.
//

import SwiftUI

// MARK: - listConfig

public extension CatTheme {

    /// Produces the `CatListStateStyleConfig` for all navigation list rows.
    ///
    /// Each state defines the full set of color slots (background, text, icon,
    /// chevron, ellipse, divider). Replace every `// TODO` value with the correct
    /// design token once the design team finalises the color decisions.
    ///
    /// State priority (highest → lowest):
    ///   disabled → pressed → hovered → focused → normal
    static func listConfig() -> CatListStateStyleConfig {

        // ── Normal ────────────────────────────────────────────────────────────
        let normal = CatListStateStyle(
            colorStyle: CatListStateColorStyle(
                background: CatColors.Theme.Primary.fill,       // color/theme/primary/fill
                text:       CatColors.Ui.Font.body,             // color/ui/font/body
                icon:       CatColors.Ui.Font.body,             // color/ui/font/body
                chevron:    CatColors.Ui.Font.muted,            // color/ui/font/muted
                ellipse:    CatColors.Theme.Danger.bg,          // color/theme/danger/bg
                divider:    CatColors.Ui.Border.regular         // color/ui/border/regular
            )
        )

        // ── Hovered ───────────────────────────────────────────────────────────
        let hovered = CatListStateStyle(
            colorStyle: CatListStateColorStyle(
                background: CatColors.Theme.Primary.fill,       // TODO: hover background token
                text:       CatColors.Ui.Font.body,             // TODO: hover text token
                icon:       CatColors.Ui.Font.body,             // TODO: hover icon token
                chevron:    CatColors.Ui.Font.muted,            // TODO: hover chevron token
                ellipse:    CatColors.Theme.Danger.bg,          // TODO: hover ellipse token
                divider:    CatColors.Ui.Border.regular         // TODO: hover divider token
            )
        )

        // ── Pressed ───────────────────────────────────────────────────────────
        let pressed = CatListStateStyle(
            colorStyle: CatListStateColorStyle(
                background: CatColors.Theme.Secondary.bgActive, // TODO: pressed background token
                text:       CatColors.Ui.Font.body,             // TODO: pressed text token
                icon:       CatColors.Ui.Font.body,             // TODO: pressed icon token
                chevron:    CatColors.Ui.Font.muted,            // TODO: pressed chevron token
                ellipse:    CatColors.Theme.Danger.bg,          // TODO: pressed ellipse token
                divider:    CatColors.Ui.Border.regular         // TODO: pressed divider token
            )
        )

        // ── Focused ───────────────────────────────────────────────────────────
        let focused = CatListStateStyle(
            colorStyle: CatListStateColorStyle(
                background: CatColors.Theme.Primary.fill,       // TODO: focused background token
                text:       CatColors.Ui.Font.body,             // TODO: focused text token
                icon:       CatColors.Ui.Font.body,             // TODO: focused icon token
                chevron:    CatColors.Ui.Font.muted,            // TODO: focused chevron token
                ellipse:    CatColors.Theme.Danger.bg,          // TODO: focused ellipse token
                divider:    CatColors.Ui.Border.regular         // TODO: focused divider token
            )
        )

        // ── Disabled ──────────────────────────────────────────────────────────
        let disabled = CatListStateStyle(
            colorStyle: CatListStateColorStyle(
                background: CatColors.Ui.Background.muted,      // TODO: disabled background token
                text:       CatColors.Ui.Font.muted,            // TODO: disabled text token
                icon:       CatColors.Ui.Font.muted,            // TODO: disabled icon token
                chevron:    CatColors.Ui.Font.muted,            // TODO: disabled chevron token
                ellipse:    CatColors.Theme.Danger.bg,          // TODO: disabled ellipse token
                divider:    CatColors.Ui.Border.regular         // TODO: disabled divider token
            )
        )

        return CatListStateStyleConfig(
            normal:   normal,
            hovered:  hovered,
            pressed:  pressed,
            focused:  focused,
            disabled: disabled
        )
    }
}
