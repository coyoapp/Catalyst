//
//  CatTheme.swift
//  Catalyst
//
//  Created by Efe Durmaz on 21.11.25.
//

import SwiftUI

public enum CatTheme {
    /// Call once during app startup to register Catalyst bundled fonts.
    public static func configure() {
        CatFontRegistrar.registerFonts()
    }

    public enum AccentColorDarkenFactor: CGFloat {
        case hovered = 0.05
        case pressed = 0.11
    }
    
    public enum ThemeKudosButton {
        public static let primaryColorConfig = CatButtonStateStyleConfig(
            normal: .init(
                colorStyle: CatButtonStateColorStyle(
                    background: Color.clear,
                    foreground: CatColors.theme.primary.text,
                    border: CatColors.theme.secondary.bg)
            ),
            pressed: .init(
                colorStyle: CatButtonStateColorStyle(
                    background: Color.clear.opacity(0.5),
                    foreground: CatColors.theme.primary.text.opacity(0.5),
                    border: CatColors.theme.secondary.bg.opacity(0.5)
                )
            ),
            focused: .init(
                colorStyle: CatButtonStateColorStyle(
                    background: Color.clear.opacity(0.5),
                    foreground: CatColors.theme.primary.text.opacity(0.5),
                    border: CatColors.theme.secondary.bg.opacity(0.5)
                )
            ),
            disabled: .init(
                colorStyle: CatButtonStateColorStyle(
                    background: CatColors.theme.primaryInverted.bgActive,
                    foreground: CatColors.theme.primaryInverted.fill,
                    border: CatColors.theme.secondary.bg
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
    
    // MARK: - COMPONENTS
    public enum Components {
        public enum Buttons {
            // ACCENT COLOR BUTTON CONFIG
            public enum Accent {
                public static func filledConfig(accentColor: Color) -> CatButtonStateStyleConfig {
                    CatButtonStateStyleConfig(
                        normal: .init(
                            colorStyle: CatButtonStateColorStyle(
                                background: accentColor,
                                foreground: CatColors.theme.primary.fill,
                                border: Color.clear),
                            properties: CatStateProperties(
                                isUnderlined: false,
                                hasSecondaryFocusRing: false,
                                scale: 1)
                        ),
                        hovered: .init(
                            colorStyle: CatButtonStateColorStyle(
                                background: accentColor.darken(by: AccentColorDarkenFactor.hovered.rawValue),
                                foreground: CatColors.theme.primary.fillHover,
                                border: Color.clear
                            ),
                            properties: CatStateProperties(
                                isUnderlined: false,
                                hasSecondaryFocusRing: false,
                                scale: 1)
                        ),
                        pressed: .init(
                            colorStyle: CatButtonStateColorStyle(
                                background: accentColor.darken(by: AccentColorDarkenFactor.pressed.rawValue),
                                foreground: CatColors.theme.primary.fillActive,
                                border: Color.clear),
                            properties: CatStateProperties(
                                isUnderlined: false,
                                hasSecondaryFocusRing: false,
                                scale: 1)
                        ),
                        focused: .init(
                            colorStyle: CatButtonStateColorStyle(
                                background: accentColor,
                                foreground: CatColors.theme.primary.fill,
                                border: Color.clear),
                            properties: CatStateProperties(
                                isUnderlined: false,
                                hasSecondaryFocusRing: true,
                                scale: 1)
                        ),
                        disabled: .init(
                            colorStyle: CatButtonStateColorStyle(
                                background: CatColors.ui.background.muted,
                                foreground: CatColors.ui.font.muted,
                                border: Color.clear),
                            properties: CatStateProperties(
                                isUnderlined: false,
                                hasSecondaryFocusRing: false,
                                scale: 1)
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
                                border: accentColor
                            ),
                            properties: CatStateProperties(
                                isUnderlined: false,
                                hasSecondaryFocusRing: false,
                                scale: 1)
                        ),
                        hovered: .init(
                            colorStyle: CatButtonStateColorStyle(
                                background: CatColors.theme.primary.bgHover,
                                foreground: accentColor,
                                border: accentColor.darken(by: AccentColorDarkenFactor.hovered.rawValue)
                            ),
                            properties: CatStateProperties(
                                isUnderlined: false,
                                hasSecondaryFocusRing: false,
                                scale: 1)
                        ),
                        pressed: .init(
                            colorStyle: CatButtonStateColorStyle(
                                background: CatColors.theme.primary.bgActive,
                                foreground: accentColor,
                                border: accentColor.darken(by: AccentColorDarkenFactor.pressed.rawValue)
                            ),
                            properties: CatStateProperties(
                                isUnderlined: false,
                                hasSecondaryFocusRing: false,
                                scale: 1)
                        ),
                        focused: .init(
                            colorStyle: CatButtonStateColorStyle(
                                background: Color.clear,
                                foreground: accentColor,
                                border: accentColor
                            ),
                            properties: CatStateProperties(
                                isUnderlined: false,
                                hasSecondaryFocusRing: true,
                                scale: 1)
                        ),
                        disabled: .init(
                            colorStyle: CatButtonStateColorStyle(
                                background: Color.clear,
                                foreground: CatColors.ui.font.muted,
                                border: CatColors.ui.font.muted
                            ),
                            properties: CatStateProperties(
                                isUnderlined: false,
                                hasSecondaryFocusRing: false,
                                scale: 1)
                        )
                    )
                }
                
                public static func ghostConfig(accentColor: Color) -> CatButtonStateStyleConfig {
                    CatButtonStateStyleConfig(
                        normal: .init(
                            colorStyle: CatButtonStateColorStyle(
                                background: Color.clear,
                                foreground: accentColor,
                                border: Color.clear
                            ),
                            properties: CatStateProperties(
                                isUnderlined: false,
                                hasSecondaryFocusRing: false,
                                scale: 1)
                        ),
                        hovered: .init(
                            colorStyle: CatButtonStateColorStyle(
                                background: CatColors.theme.primary.bgHover,
                                foreground: accentColor,
                                border: Color.clear
                            ),
                            properties: CatStateProperties(
                                isUnderlined: true,
                                hasSecondaryFocusRing: false,
                                scale: 1)
                        ),
                        pressed: .init(
                            colorStyle: CatButtonStateColorStyle(
                                background: CatColors.theme.primary.bgActive,
                                foreground: accentColor,
                                border: Color.clear
                            ),
                            properties: CatStateProperties(
                                isUnderlined: false,
                                hasSecondaryFocusRing: false,
                                scale: 1)
                        ),
                        focused: .init(
                            colorStyle: CatButtonStateColorStyle(
                                background: Color.clear,
                                foreground: accentColor,
                                border: Color.clear
                            ),
                            properties: CatStateProperties(
                                isUnderlined: false,
                                hasSecondaryFocusRing: true,
                                scale: 1)
                        ),
                        disabled: .init(
                            colorStyle: CatButtonStateColorStyle(
                                background: Color.clear,
                                foreground: CatColors.ui.font.muted,
                                border: Color.clear
                            ),
                            properties: CatStateProperties(
                                isUnderlined: false,
                                hasSecondaryFocusRing: false,
                                scale: 1)
                        )
                    )
                }
                
                public static func linkConfig(accentColor: Color) -> CatButtonStateStyleConfig {
                    CatButtonStateStyleConfig(
                        normal: .init(
                            colorStyle: CatButtonStateColorStyle(
                                background: Color.clear,
                                foreground: accentColor,
                                border: Color.clear
                            ),
                            properties: CatStateProperties(
                                isUnderlined: false,
                                hasSecondaryFocusRing: false,
                                scale: 1)
                        ),
                        hovered: .init(
                            colorStyle: CatButtonStateColorStyle(
                                background: Color.clear,
                                foreground: accentColor.darken(by: AccentColorDarkenFactor.hovered.rawValue),
                                border: Color.clear
                            ),
                            properties: CatStateProperties(
                                isUnderlined: true,
                                hasSecondaryFocusRing: false,
                                scale: 1)
                        ),
                        pressed: .init(
                            colorStyle: CatButtonStateColorStyle(
                                background: Color.clear,
                                foreground: accentColor.darken(by: AccentColorDarkenFactor.pressed.rawValue),
                                border: Color.clear
                            ),
                            properties: CatStateProperties(
                                isUnderlined: true,
                                hasSecondaryFocusRing: false,
                                scale: 1)
                        ),
                        focused: .init(
                            colorStyle: CatButtonStateColorStyle(
                                background: Color.clear,
                                foreground: accentColor,
                                border: Color.clear
                            ),
                            properties: CatStateProperties(
                                isUnderlined: false,
                                hasSecondaryFocusRing: true,
                                scale: 1)
                        ),
                        disabled: .init(
                            colorStyle: CatButtonStateColorStyle(
                                background: Color.clear,
                                foreground: CatColors.ui.font.muted,
                                border: Color.clear
                            ),
                            properties: CatStateProperties(
                                isUnderlined: false,
                                hasSecondaryFocusRing: false,
                                scale: 1)
                        )
                    )
                }
            }
            
            public enum Primary {
                // FILLED BUTTON CONFIG
                public static let filledConfig = CatButtonStateStyleConfig(
                    normal: .init(
                        colorStyle: CatButtonStateColorStyle(
                            background: CatColors.theme.primary.bg,
                            foreground: CatColors.theme.primary.fill,
                            border: Color.clear
                        ),
                        properties: CatStateProperties(
                            isUnderlined: false,
                            hasSecondaryFocusRing: false,
                            scale: 1)
                    ),
                    hovered: .init(
                        colorStyle: CatButtonStateColorStyle(
                            background: CatColors.theme.primary.bgHover,
                            foreground: CatColors.theme.primary.fillHover,
                            border: Color.clear
                        ),
                        properties: CatStateProperties(
                            isUnderlined: false,
                            hasSecondaryFocusRing: false,
                            scale: 1)
                    ),
                    pressed: .init(
                        colorStyle: CatButtonStateColorStyle(
                            background: CatColors.theme.primary.bgActive,
                            foreground: CatColors.theme.primary.fillActive,
                            border: Color.clear
                        ),
                        properties: CatStateProperties(
                            isUnderlined: false,
                            hasSecondaryFocusRing: false,
                            scale: 1)
                    ),
                    focused: .init(
                        colorStyle: CatButtonStateColorStyle(
                            background: CatColors.theme.primary.bg,
                            foreground: CatColors.theme.primary.fill,
                            border: Color.clear
                        ),
                        properties: CatStateProperties(
                            isUnderlined: false,
                            hasSecondaryFocusRing: true,
                            scale: 1)
                    ),
                    disabled: .init(
                        colorStyle: CatButtonStateColorStyle(
                            background: CatColors.ui.background.muted,
                            foreground: CatColors.ui.font.muted,
                            border: Color.clear
                        ),
                        properties: CatStateProperties(
                            isUnderlined: false,
                            hasSecondaryFocusRing: false,
                            scale: 1)
                    )
                )
                
                public static let borderConfig = CatButtonStateStyleConfig(
                    normal: .init(
                        colorStyle: CatButtonStateColorStyle(
                            background: Color.clear,
                            foreground: CatColors.theme.primary.text,
                            border: CatColors.theme.primary.bg
                        ),
                        properties: CatStateProperties(
                            isUnderlined: false,
                            hasSecondaryFocusRing: false,
                            scale: 1)
                    ),
                    hovered: .init(
                        colorStyle: CatButtonStateColorStyle(
                            background: CatColors.theme.primary.bgHover,
                            foreground: CatColors.theme.primary.text,
                            border: CatColors.theme.primary.bg
                        ),
                        properties: CatStateProperties(
                            isUnderlined: false,
                            hasSecondaryFocusRing: false,
                            scale: 1)
                    ),
                    pressed: .init(
                        colorStyle: CatButtonStateColorStyle(
                            background: CatColors.theme.primary.bgActive,
                            foreground: CatColors.theme.primary.text,
                            border: CatColors.theme.primary.bg
                        ),
                        properties: CatStateProperties(
                            isUnderlined: false,
                            hasSecondaryFocusRing: false,
                            scale: 1)
                    ),
                    focused: .init(
                        colorStyle: CatButtonStateColorStyle(
                            background: Color.clear,
                            foreground: CatColors.theme.primary.text,
                            border: CatColors.theme.primary.bg
                        ),
                        properties: CatStateProperties(
                            isUnderlined: false,
                            hasSecondaryFocusRing: true,
                            scale: 1)
                    ),
                    disabled: .init(
                        colorStyle: CatButtonStateColorStyle(
                            background: Color.clear,
                            foreground: CatColors.ui.font.muted,
                            border: CatColors.ui.font.muted
                        ),
                        properties: CatStateProperties(
                            isUnderlined: false,
                            hasSecondaryFocusRing: false,
                            scale: 1)
                    )
                )
                
                public static let ghostConfig = CatButtonStateStyleConfig(
                    normal: .init(
                        colorStyle: CatButtonStateColorStyle(
                            background: Color.clear,
                            foreground: CatColors.theme.primary.text,
                            border: Color.clear
                        ),
                        properties: CatStateProperties(
                            isUnderlined: false,
                            hasSecondaryFocusRing: false,
                            scale: 1)
                    ),
                    hovered: .init(
                        colorStyle: CatButtonStateColorStyle(
                            background: CatColors.theme.primary.bgHover,
                            foreground: CatColors.theme.primary.text,
                            border: Color.clear
                        ),
                        properties: CatStateProperties(
                            isUnderlined: false,
                            hasSecondaryFocusRing: false,
                            scale: 1)
                    ),
                    pressed: .init(
                        colorStyle: CatButtonStateColorStyle(
                            background: CatColors.theme.primary.bgActive,
                            foreground: CatColors.theme.primary.text,
                            border: Color.clear
                        ),
                        properties: CatStateProperties(
                            isUnderlined: false,
                            hasSecondaryFocusRing: false,
                            scale: 1)
                    ),
                    focused: .init(
                        colorStyle: CatButtonStateColorStyle(
                            background: Color.clear,
                            foreground: CatColors.theme.primary.text,
                            border: Color.clear
                        ),
                        properties: CatStateProperties(
                            isUnderlined: false,
                            hasSecondaryFocusRing: true,
                            scale: 1)
                    ),
                    disabled: .init(
                        colorStyle: CatButtonStateColorStyle(
                            background: Color.clear,
                            foreground: CatColors.ui.font.muted,
                            border: Color.clear
                        ),
                        properties: CatStateProperties(
                            isUnderlined: false,
                            hasSecondaryFocusRing: false,
                            scale: 1)
                    )
                )
                
                public static let linkConfig = CatButtonStateStyleConfig(
                    normal: .init(
                        colorStyle: CatButtonStateColorStyle(
                            background: Color.clear,
                            foreground: CatColors.theme.primary.text,
                            border: Color.clear
                        ),
                        properties: CatStateProperties(
                            isUnderlined: false,
                            hasSecondaryFocusRing: false,
                            scale: 1)
                    ),
                    hovered: .init(
                        colorStyle: CatButtonStateColorStyle(
                            background: Color.clear,
                            foreground: CatColors.theme.primary.text,
                            border: Color.clear
                        ),
                        properties: CatStateProperties(
                            isUnderlined: true,
                            hasSecondaryFocusRing: false,
                            scale: 1)
                    ),
                    pressed: .init(
                        colorStyle: CatButtonStateColorStyle(
                            background: Color.clear,
                            foreground: CatColors.theme.primary.text,
                            border: Color.clear
                        ),
                        properties: CatStateProperties(
                            isUnderlined: true,
                            hasSecondaryFocusRing: false,
                            scale: 1)
                    ),
                    focused: .init(
                        colorStyle: CatButtonStateColorStyle(
                            background: Color.clear,
                            foreground: CatColors.theme.primary.text,
                            border: Color.clear
                        ),
                        properties: CatStateProperties(
                            isUnderlined: false,
                            hasSecondaryFocusRing: true,
                            scale: 1)
                    ),
                    disabled: .init(
                        colorStyle: CatButtonStateColorStyle(
                            background: Color.clear,
                            foreground: CatColors.ui.font.muted,
                            border: Color.clear
                        ),
                        properties: CatStateProperties(
                            isUnderlined: false,
                            hasSecondaryFocusRing: false,
                            scale: 1)
                    )
                )
            }
        }
    }
}
