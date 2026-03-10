//
//  CatTheme+Button.swift
//  Catalyst
//
//  Created by Efe Durmaz on 09.13.26.
//

import SwiftUI

// MARK: - buttonConfig

public extension CatTheme {

    /// Resolves a `CatButtonStateStyleConfig` for the given variant and color combination.
    ///
    /// This is the single source of truth that maps `(ButtonVariant × ColorConfig)` onto the
    /// design-token colors in `CatColors.Theme.*`. Use `.catButtonConfig(variant:color:)` on a
    /// view to inject this into the SwiftUI environment instead of passing `styleConfig:` directly.
    ///
    /// - Parameters:
    ///   - variant: The visual shape of the button (`.filled`, `.outlined`, `.text`, `.link`).
    ///   - color: The semantic color role from `CatColors.Theme` (`.primary`, `.danger`, etc.).
    ///   - theme: The active theme. Defaults to `CatTheme.current`. Pass explicitly if needed.
    /// - Returns: A fully-resolved `CatButtonStateStyleConfig` for all interaction states.
    static func buttonConfig(
        variant: ButtonVariant = .filled,
        color: ColorConfig = .primary,
        theme: ThemeType = CatTheme.current
    ) -> CatButtonStateStyleConfig {

        let p = color.palette(for: theme)

        // Shared disabled states — always muted regardless of variant/color.
        let disabledState = CatButtonStateStyle(
            colorStyle: CatButtonStateColorStyle(
                background: Color.clear,
                foreground: CatColors.Ui.Font.muted,
                border: Color.clear
            ),
            properties: CatStateProperties(isUnderlined: false, hasSecondaryFocusRing: false, scale: 1)
        )
        let filledDisabledState = CatButtonStateStyle(
            colorStyle: CatButtonStateColorStyle(
                background: CatColors.Ui.Background.muted,
                foreground: CatColors.Ui.Font.muted,
                border: Color.clear
            ),
            properties: CatStateProperties(isUnderlined: false, hasSecondaryFocusRing: false, scale: 1)
        )

        switch variant {

        // MARK: Filled — solid background, white fill
        case .filled:
            return CatButtonStateStyleConfig(
                normal: .init(
                    colorStyle: CatButtonStateColorStyle(background: p.bg, foreground: p.fill, border: Color.clear),
                    properties: CatStateProperties(isUnderlined: false, hasSecondaryFocusRing: false, scale: 1)
                ),
                hovered: .init(
                    colorStyle: CatButtonStateColorStyle(background: p.bgHover, foreground: p.fillHover, border: Color.clear),
                    properties: CatStateProperties(isUnderlined: false, hasSecondaryFocusRing: false, scale: 1)
                ),
                pressed: .init(
                    colorStyle: CatButtonStateColorStyle(background: p.bgActive, foreground: p.fillActive, border: Color.clear),
                    properties: CatStateProperties(isUnderlined: false, hasSecondaryFocusRing: false, scale: 1)
                ),
                focused: .init(
                    colorStyle: CatButtonStateColorStyle(background: p.bg, foreground: p.fill, border: Color.clear),
                    properties: CatStateProperties(isUnderlined: false, hasSecondaryFocusRing: true, scale: 1)
                ),
                disabled: filledDisabledState
            )

        // MARK: Outlined — transparent background, colored border and text
        case .outlined:
            return CatButtonStateStyleConfig(
                normal: .init(
                    colorStyle: CatButtonStateColorStyle(background: Color.clear, foreground: p.text, border: p.bg.opacity(0.20)),
                    properties: CatStateProperties(isUnderlined: false, hasSecondaryFocusRing: false, scale: 1)
                ),
                hovered: .init(
                    colorStyle: CatButtonStateColorStyle(background: p.bgHover.opacity(0.05), foreground: p.text, border: p.bg.opacity(0.20)),
                    properties: CatStateProperties(isUnderlined: false, hasSecondaryFocusRing: false, scale: 1)
                ),
                pressed: .init(
                    colorStyle: CatButtonStateColorStyle(background: p.bgActive.opacity(0.15), foreground: p.text, border: p.bg.opacity(0.20)),
                    properties: CatStateProperties(isUnderlined: false, hasSecondaryFocusRing: false, scale: 1)
                ),
                focused: .init(
                    colorStyle: CatButtonStateColorStyle(background: Color.clear, foreground: p.text, border: p.bg.opacity(0.20)),
                    properties: CatStateProperties(isUnderlined: false, hasSecondaryFocusRing: true, scale: 1)
                ),
                disabled: CatButtonStateStyle(
                    colorStyle: CatButtonStateColorStyle(
                        background: Color.clear,
                        foreground: CatColors.Ui.Font.muted,
                        border: CatColors.Ui.Font.muted.opacity(0.20)
                    ),
                    properties: CatStateProperties(isUnderlined: false, hasSecondaryFocusRing: false, scale: 1)
                )
            )

        // MARK: Text (ghost) — transparent background, no border, colored text
        case .text:
            return CatButtonStateStyleConfig(
                normal: .init(
                    colorStyle: CatButtonStateColorStyle(background: Color.clear, foreground: p.text, border: Color.clear),
                    properties: CatStateProperties(isUnderlined: false, hasSecondaryFocusRing: false, scale: 1)
                ),
                hovered: .init(
                    colorStyle: CatButtonStateColorStyle(background: p.bgHover.opacity(0.05), foreground: p.textHover, border: Color.clear),
                    properties: CatStateProperties(isUnderlined: false, hasSecondaryFocusRing: false, scale: 1)
                ),
                pressed: .init(
                    colorStyle: CatButtonStateColorStyle(background: p.bgActive.opacity(0.15), foreground: p.textActive, border: Color.clear),
                    properties: CatStateProperties(isUnderlined: false, hasSecondaryFocusRing: false, scale: 1)
                ),
                focused: .init(
                    colorStyle: CatButtonStateColorStyle(background: Color.clear, foreground: p.text, border: Color.clear),
                    properties: CatStateProperties(isUnderlined: false, hasSecondaryFocusRing: true, scale: 1)
                ),
                disabled: disabledState
            )

        // MARK: Link — transparent, no border, underline on hover/press
        case .link:
            return CatButtonStateStyleConfig(
                normal: .init(
                    colorStyle: CatButtonStateColorStyle(background: Color.clear, foreground: p.text, border: Color.clear),
                    properties: CatStateProperties(isUnderlined: false, hasSecondaryFocusRing: false, scale: 1)
                ),
                hovered: .init(
                    colorStyle: CatButtonStateColorStyle(background: Color.clear, foreground: p.textHover, border: Color.clear),
                    properties: CatStateProperties(isUnderlined: true, hasSecondaryFocusRing: false, scale: 1)
                ),
                pressed: .init(
                    colorStyle: CatButtonStateColorStyle(background: Color.clear, foreground: p.textActive, border: Color.clear),
                    properties: CatStateProperties(isUnderlined: true, hasSecondaryFocusRing: false, scale: 1)
                ),
                focused: .init(
                    colorStyle: CatButtonStateColorStyle(background: Color.clear, foreground: p.text, border: Color.clear),
                    properties: CatStateProperties(isUnderlined: false, hasSecondaryFocusRing: true, scale: 1)
                ),
                disabled: disabledState
            )
        }
    }
}

// MARK: - ThemeKudosButton

public extension CatTheme {

    enum ThemeKudosButton {
        public static let primaryColorConfig = CatButtonStateStyleConfig(
            normal: .init(
                colorStyle: CatButtonStateColorStyle(
                    background: Color.clear,
                    foreground: CatColors.Theme.Primary.text,
                    border: CatColors.Theme.Secondary.bg)
            ),
            pressed: .init(
                colorStyle: CatButtonStateColorStyle(
                    background: Color.clear.opacity(0.5),
                    foreground: CatColors.Theme.Primary.text.opacity(0.5),
                    border: CatColors.Theme.Secondary.bg.opacity(0.5)
                )
            ),
            focused: .init(
                colorStyle: CatButtonStateColorStyle(
                    background: Color.clear.opacity(0.5),
                    foreground: CatColors.Theme.Primary.text.opacity(0.5),
                    border: CatColors.Theme.Secondary.bg.opacity(0.5)
                )
            ),
            disabled: .init(
                colorStyle: CatButtonStateColorStyle(
                    background: CatColors.Theme.PrimaryInverted.bgActive,
                    foreground: CatColors.Theme.PrimaryInverted.fill,
                    border: CatColors.Theme.Secondary.bg
                )
            )
        )

        public static let padding = EdgeInsets(
            top: CatSpacing.spacing3xl,
            leading: CatSpacing.spacingMd,
            bottom: CatSpacing.spacing3xl,
            trailing: CatSpacing.spacingMd
        )
    }
}

// MARK: - Components.Buttons (legacy static configs — kept for Accent Color compatibility)

public extension CatTheme {

    // NOTE: These static configs are kept for backward compatibility and will be removed
    // in a future release. Prefer `.catButtonConfig(variant:color:)` on your views instead.
    enum Components {
        public enum Buttons {

            // MARK: Accent (dynamic accent color)
            public enum Accent {
                public static func filledConfig(accentColor: Color) -> CatButtonStateStyleConfig {
                    CatButtonStateStyleConfig(
                        normal: .init(
                            colorStyle: CatButtonStateColorStyle(
                                background: accentColor,
                                foreground: CatColors.Theme.Primary.fill,
                                border: Color.clear),
                            properties: CatStateProperties(isUnderlined: false, hasSecondaryFocusRing: false, scale: 1)
                        ),
                        hovered: .init(
                            colorStyle: CatButtonStateColorStyle(
                                background: accentColor.darken(by: AccentColorDarkenFactor.hovered.rawValue),
                                foreground: CatColors.Theme.Primary.fillHover,
                                border: Color.clear),
                            properties: CatStateProperties(isUnderlined: false, hasSecondaryFocusRing: false, scale: 1)
                        ),
                        pressed: .init(
                            colorStyle: CatButtonStateColorStyle(
                                background: accentColor.darken(by: AccentColorDarkenFactor.pressed.rawValue),
                                foreground: CatColors.Theme.Primary.fillActive,
                                border: Color.clear),
                            properties: CatStateProperties(isUnderlined: false, hasSecondaryFocusRing: false, scale: 1)
                        ),
                        focused: .init(
                            colorStyle: CatButtonStateColorStyle(
                                background: accentColor,
                                foreground: CatColors.Theme.Primary.fill,
                                border: Color.clear),
                            properties: CatStateProperties(isUnderlined: false, hasSecondaryFocusRing: true, scale: 1)
                        ),
                        disabled: .init(
                            colorStyle: CatButtonStateColorStyle(
                                background: CatColors.Ui.Background.muted,
                                foreground: CatColors.Ui.Font.muted,
                                border: Color.clear),
                            properties: CatStateProperties(isUnderlined: false, hasSecondaryFocusRing: false, scale: 1)
                        )
                    )
                }

                // TODO: ASK BACKGROUND AND BORDER COLOR Configs
                public static func borderConfig(accentColor: Color) -> CatButtonStateStyleConfig {
                    CatButtonStateStyleConfig(
                        normal: .init(
                            colorStyle: CatButtonStateColorStyle(
                                background: Color.clear,
                                foreground: accentColor,
                                border: accentColor),
                            properties: CatStateProperties(isUnderlined: false, hasSecondaryFocusRing: false, scale: 1)
                        ),
                        hovered: .init(
                            colorStyle: CatButtonStateColorStyle(
                                background: CatColors.Theme.Primary.bgHover,
                                foreground: accentColor,
                                border: accentColor.darken(by: AccentColorDarkenFactor.hovered.rawValue)),
                            properties: CatStateProperties(isUnderlined: false, hasSecondaryFocusRing: false, scale: 1)
                        ),
                        pressed: .init(
                            colorStyle: CatButtonStateColorStyle(
                                background: CatColors.Theme.Primary.bgActive,
                                foreground: accentColor,
                                border: accentColor.darken(by: AccentColorDarkenFactor.pressed.rawValue)),
                            properties: CatStateProperties(isUnderlined: false, hasSecondaryFocusRing: false, scale: 1)
                        ),
                        focused: .init(
                            colorStyle: CatButtonStateColorStyle(
                                background: Color.clear,
                                foreground: accentColor,
                                border: accentColor),
                            properties: CatStateProperties(isUnderlined: false, hasSecondaryFocusRing: true, scale: 1)
                        ),
                        disabled: .init(
                            colorStyle: CatButtonStateColorStyle(
                                background: Color.clear,
                                foreground: CatColors.Ui.Font.muted,
                                border: CatColors.Ui.Font.muted),
                            properties: CatStateProperties(isUnderlined: false, hasSecondaryFocusRing: false, scale: 1)
                        )
                    )
                }

                public static func ghostConfig(accentColor: Color) -> CatButtonStateStyleConfig {
                    CatButtonStateStyleConfig(
                        normal: .init(
                            colorStyle: CatButtonStateColorStyle(
                                background: Color.clear,
                                foreground: accentColor,
                                border: Color.clear),
                            properties: CatStateProperties(isUnderlined: false, hasSecondaryFocusRing: false, scale: 1)
                        ),
                        hovered: .init(
                            colorStyle: CatButtonStateColorStyle(
                                background: CatColors.Theme.Primary.bgHover,
                                foreground: accentColor,
                                border: Color.clear),
                            properties: CatStateProperties(isUnderlined: true, hasSecondaryFocusRing: false, scale: 1)
                        ),
                        pressed: .init(
                            colorStyle: CatButtonStateColorStyle(
                                background: CatColors.Theme.Primary.bgActive,
                                foreground: accentColor,
                                border: Color.clear),
                            properties: CatStateProperties(isUnderlined: false, hasSecondaryFocusRing: false, scale: 1)
                        ),
                        focused: .init(
                            colorStyle: CatButtonStateColorStyle(
                                background: Color.clear,
                                foreground: accentColor,
                                border: Color.clear),
                            properties: CatStateProperties(isUnderlined: false, hasSecondaryFocusRing: true, scale: 1)
                        ),
                        disabled: .init(
                            colorStyle: CatButtonStateColorStyle(
                                background: Color.clear,
                                foreground: CatColors.Ui.Font.muted,
                                border: Color.clear),
                            properties: CatStateProperties(isUnderlined: false, hasSecondaryFocusRing: false, scale: 1)
                        )
                    )
                }

                public static func linkConfig(accentColor: Color) -> CatButtonStateStyleConfig {
                    CatButtonStateStyleConfig(
                        normal: .init(
                            colorStyle: CatButtonStateColorStyle(
                                background: Color.clear,
                                foreground: accentColor,
                                border: Color.clear),
                            properties: CatStateProperties(isUnderlined: false, hasSecondaryFocusRing: false, scale: 1)
                        ),
                        hovered: .init(
                            colorStyle: CatButtonStateColorStyle(
                                background: Color.clear,
                                foreground: accentColor.darken(by: AccentColorDarkenFactor.hovered.rawValue),
                                border: Color.clear),
                            properties: CatStateProperties(isUnderlined: true, hasSecondaryFocusRing: false, scale: 1)
                        ),
                        pressed: .init(
                            colorStyle: CatButtonStateColorStyle(
                                background: Color.clear,
                                foreground: accentColor.darken(by: AccentColorDarkenFactor.pressed.rawValue),
                                border: Color.clear),
                            properties: CatStateProperties(isUnderlined: true, hasSecondaryFocusRing: false, scale: 1)
                        ),
                        focused: .init(
                            colorStyle: CatButtonStateColorStyle(
                                background: Color.clear,
                                foreground: accentColor,
                                border: Color.clear),
                            properties: CatStateProperties(isUnderlined: false, hasSecondaryFocusRing: true, scale: 1)
                        ),
                        disabled: .init(
                            colorStyle: CatButtonStateColorStyle(
                                background: Color.clear,
                                foreground: CatColors.Ui.Font.muted,
                                border: Color.clear),
                            properties: CatStateProperties(isUnderlined: false, hasSecondaryFocusRing: false, scale: 1)
                        )
                    )
                }
            }
        }
    }
}
