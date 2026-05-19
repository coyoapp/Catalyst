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

        // Normal
        let normal = CatListStateStyle(
            colorStyle: CatListStateColorStyle(
                background: CatColors.Theme.Primary.fill, // color/theme/primary/fill
                text: CatColors.Ui.Font.body, // color/ui/font/body
                subtitle: CatColors.Ui.Font.muted,
                icon: CatColors.Ui.Font.body, // color/ui/font/body
                chevron: CatColors.Ui.Font.muted, // color/ui/font/muted
                ellipse: CatColors.Theme.Danger.bg, // color/theme/danger/bg
                divider: CatColors.Ui.Border.regular // color/ui/border/regular
            )
        )

        // Hovered
        let hovered = CatListStateStyle(
            colorStyle: CatListStateColorStyle(
                background: CatColors.Theme.Secondary.bgHover.opacity(0.1),
                text: CatColors.Ui.Font.body,
                subtitle: CatColors.Ui.Font.muted,
                icon: CatColors.Ui.Font.body,
                chevron: CatColors.Ui.Font.muted,
                ellipse: CatColors.Theme.Danger.bg,
                divider: CatColors.Ui.Border.regular
            )
        )

        // Pressed
        let pressed = CatListStateStyle(
            colorStyle: CatListStateColorStyle(
                background: CatColors.Theme.Secondary.bgActive.opacity(0.1),
                text: CatColors.Ui.Font.body,
                subtitle: CatColors.Ui.Font.muted,
                icon: CatColors.Ui.Font.body,
                chevron: CatColors.Ui.Font.muted,
                ellipse: CatColors.Theme.Danger.bg,
                divider: CatColors.Ui.Border.regular
            )
        )

        // Focused (Design not provided so copies the Normal state)
        let focused = CatListStateStyle(
            colorStyle: CatListStateColorStyle(
                background: CatColors.Theme.Primary.fill, // TODO: Replace if it needed in desing
                text: CatColors.Ui.Font.body, // TODO: Replace if it needed in desing
                subtitle: CatColors.Ui.Font.muted,
                icon: CatColors.Ui.Font.body, // TODO: Replace if it needed in desing
                chevron: CatColors.Ui.Font.muted, // TODO: Replace if it needed in desing
                ellipse: CatColors.Theme.Danger.bg, // TODO: Replace if it needed in desing
                divider: CatColors.Ui.Border.regular // TODO: Replace if it needed in desing
            )
        )

        // Disabled
        let disabled = CatListStateStyle(
            colorStyle: CatListStateColorStyle(
                background: CatColors.Theme.Primary.fill,
                text: CatColors.Ui.Font.muted,
                subtitle: CatColors.Ui.Font.muted,
                icon: CatColors.Ui.Font.muted,
                chevron: CatColors.Ui.Font.muted,
                ellipse: CatColors.Theme.Danger.bg,
                divider: CatColors.Ui.Border.regular
            )
        )

        return CatListStateStyleConfig(
            normal: normal,
            hovered: hovered,
            pressed: pressed,
            focused: focused,
            disabled: disabled
        )
    }
}
