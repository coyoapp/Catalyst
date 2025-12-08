//
//  DSTheme.swift
//  DesignSystemKit
//
//  Created by Efe Durmaz on 21.11.25.
//

import SwiftUI

public enum DSTheme {
    
    public enum AccentColorDarkenFactor: CGFloat {
        case hovered = 0.05
        case pressed = 0.11
    }
    
    public enum ThemeKudosButton {
        public static let primaryColorConfig = DSButtonStateStyleConfig(
            normal: .init(
                colorStyle: DSButtonStateColorStyle(
                    background: Color.clear,
                    foreground: DSColors.colorThemePrimaryText,
                    border: DSColors.colorThemeSecondaryBg)
            ),
            pressed: .init(
                colorStyle: DSButtonStateColorStyle(
                    background: Color.clear.opacity(0.5),
                    foreground: DSColors.colorThemePrimaryText.opacity(0.5),
                    border: DSColors.colorThemeSecondaryBg.opacity(0.5),
                )
            ),
            focused: .init(
                colorStyle: DSButtonStateColorStyle(
                    background: Color.clear.opacity(0.5),
                    foreground: DSColors.colorThemePrimaryText.opacity(0.5),
                    border: DSColors.colorThemeSecondaryBg.opacity(0.5),
                )
            ),
            disabled: .init(
                colorStyle: DSButtonStateColorStyle(
                    background: DSColors.colorThemePrimaryInvertedBgActive,
                    foreground: DSColors.colorThemePrimaryInvertedFill,
                    border: DSColors.colorThemeSecondaryBg
                )
            )
        )
        
        public static let padding = EdgeInsets(
            top: DSSpacing.spacing3xl,
            leading: DSSpacing.spacingMd,
            bottom: DSSpacing.spacing3xl,
            trailing: DSSpacing.spacingMd
        )
    }
    
    // MARK: - COMPONENTS
    public enum Components {
        
        public enum Buttons {
            // ACCENT COLOR BUTTON CONFIG
            public enum Accent {
                public static func filledConfig(accentColor: Color) -> DSButtonStateStyleConfig {
                    DSButtonStateStyleConfig(
                        normal: .init(
                            colorStyle: DSButtonStateColorStyle(
                                background: accentColor,
                                foreground: DSColors.colorThemePrimaryFill,
                                border: Color.clear),
                            properties: DSStateProperties(
                                isUnderlined: false,
                                hasSecondaryFocusRing: false,
                                scale: 1)
                        ),
                        hovered: .init(
                            colorStyle: DSButtonStateColorStyle(
                                background: accentColor.darken(by: AccentColorDarkenFactor.hovered.rawValue),
                                foreground: DSColors.colorThemePrimaryFillHover,
                                border: Color.clear
                            ),
                            properties: DSStateProperties(
                                isUnderlined: false,
                                hasSecondaryFocusRing: false,
                                scale: 1)
                        ),
                        pressed: .init(
                            colorStyle: DSButtonStateColorStyle(
                                background: accentColor.darken(by: AccentColorDarkenFactor.pressed.rawValue),
                                foreground: DSColors.colorThemePrimaryFillActive,
                                border: Color.clear),
                            properties: DSStateProperties(
                                isUnderlined: false,
                                hasSecondaryFocusRing: false,
                                scale: 1)
                        ),
                        focused: .init(
                            colorStyle: DSButtonStateColorStyle(
                                background: accentColor,
                                foreground: DSColors.colorThemePrimaryFill,
                                border: Color.clear),
                            properties: DSStateProperties(
                                isUnderlined: false,
                                hasSecondaryFocusRing: true,
                                scale: 1)
                        ),
                        disabled: .init(
                            colorStyle: DSButtonStateColorStyle(
                                background: DSColors.colorUiBackgroundMuted,
                                foreground: DSColors.colorUiFontMuted,
                                border: Color.clear),
                            properties: DSStateProperties(
                                isUnderlined: false,
                                hasSecondaryFocusRing: false,
                                scale: 1)
                        )
                    )
                }
                // TODO: ASK BACKGROUND AND BORDER COLOR Configs
                public static func borderConfig(accentColor: Color)  -> DSButtonStateStyleConfig {
                    DSButtonStateStyleConfig(
                        normal: .init(
                            colorStyle: DSButtonStateColorStyle(
                                background: Color.clear,
                                foreground: accentColor,
                                border: accentColor
                            ),
                            properties: DSStateProperties(
                                isUnderlined: false,
                                hasSecondaryFocusRing: false,
                                scale: 1)
                        ),
                        hovered: .init(
                            colorStyle: DSButtonStateColorStyle(
                                background: DSColors.colorThemePrimaryBgHover,
                                foreground: accentColor,
                                border: accentColor.darken(by: AccentColorDarkenFactor.hovered.rawValue)
                            ),
                            properties: DSStateProperties(
                                isUnderlined: false,
                                hasSecondaryFocusRing: false,
                                scale: 1)
                        ),
                        pressed: .init(
                            colorStyle: DSButtonStateColorStyle(
                                background: DSColors.colorThemePrimaryBgActive,
                                foreground: accentColor,
                                border: accentColor.darken(by: AccentColorDarkenFactor.pressed.rawValue)
                            ),
                            properties: DSStateProperties(
                                isUnderlined: false,
                                hasSecondaryFocusRing: false,
                                scale: 1)
                        ),
                        focused: .init(
                            colorStyle: DSButtonStateColorStyle(
                                background: Color.clear,
                                foreground: accentColor,
                                border: accentColor
                            ),
                            properties: DSStateProperties(
                                isUnderlined: false,
                                hasSecondaryFocusRing: true,
                                scale: 1)
                        ),
                        disabled: .init(
                            colorStyle: DSButtonStateColorStyle(
                                background: Color.clear,
                                foreground: DSColors.colorUiFontMuted,
                                border: DSColors.colorUiFontMuted
                            ),
                            properties: DSStateProperties(
                                isUnderlined: false,
                                hasSecondaryFocusRing: false,
                                scale: 1)
                        )
                    )
                }
                
                public static func ghostConfig(accentColor: Color) -> DSButtonStateStyleConfig {
                    DSButtonStateStyleConfig(
                        normal: .init(
                            colorStyle: DSButtonStateColorStyle(
                                background: Color.clear,
                                foreground: accentColor,
                                border: Color.clear
                            ),
                            properties: DSStateProperties(
                                isUnderlined: false,
                                hasSecondaryFocusRing: false,
                                scale: 1)
                        ),
                        hovered: .init(
                            colorStyle: DSButtonStateColorStyle(
                                background: DSColors.colorThemePrimaryBgHover,
                                foreground: accentColor,
                                border: Color.clear
                            ),
                            properties: DSStateProperties(
                                isUnderlined: true,
                                hasSecondaryFocusRing: false,
                                scale: 1)
                        ),
                        pressed: .init(
                            colorStyle: DSButtonStateColorStyle(
                                background: DSColors.colorThemePrimaryBgActive,
                                foreground: accentColor,
                                border: Color.clear
                            ),
                            properties: DSStateProperties(
                                isUnderlined: false,
                                hasSecondaryFocusRing: false,
                                scale: 1)
                        ),
                        focused: .init(
                            colorStyle: DSButtonStateColorStyle(
                                background: Color.clear,
                                foreground: accentColor,
                                border: Color.clear
                            ),
                            properties: DSStateProperties(
                                isUnderlined: false,
                                hasSecondaryFocusRing: true,
                                scale: 1)
                        ),
                        disabled: .init(
                            colorStyle: DSButtonStateColorStyle(
                                background: Color.clear,
                                foreground: DSColors.colorUiFontMuted,
                                border: Color.clear
                            ),
                            properties: DSStateProperties(
                                isUnderlined: false,
                                hasSecondaryFocusRing: false,
                                scale: 1)
                        )
                    )
                }
                
                public static func linkConfig(accentColor: Color) -> DSButtonStateStyleConfig {
                    DSButtonStateStyleConfig(
                        normal: .init(
                            colorStyle: DSButtonStateColorStyle(
                                background: Color.clear,
                                foreground: accentColor,
                                border: Color.clear
                            ),
                            properties: DSStateProperties(
                                isUnderlined: false,
                                hasSecondaryFocusRing: false,
                                scale: 1)
                        ),
                        hovered: .init(
                            colorStyle: DSButtonStateColorStyle(
                                background: Color.clear,
                                foreground: accentColor.darken(by: AccentColorDarkenFactor.hovered.rawValue),
                                border: Color.clear
                            ),
                            properties: DSStateProperties(
                                isUnderlined: true,
                                hasSecondaryFocusRing: false,
                                scale: 1)
                        ),
                        pressed: .init(
                            colorStyle: DSButtonStateColorStyle(
                                background: Color.clear,
                                foreground: accentColor.darken(by: AccentColorDarkenFactor.pressed.rawValue),
                                border: Color.clear
                            ),
                            properties: DSStateProperties(
                                isUnderlined: true,
                                hasSecondaryFocusRing: true,
                                scale: 1)
                        ),
                        focused: .init(
                            colorStyle: DSButtonStateColorStyle(
                                background: Color.clear,
                                foreground: accentColor,
                                border: Color.clear
                            ),
                            properties: DSStateProperties(
                                isUnderlined: true,
                                hasSecondaryFocusRing: true,
                                scale: 1)
                        ),
                        disabled: .init(
                            colorStyle: DSButtonStateColorStyle(
                                background: Color.clear,
                                foreground: DSColors.colorUiFontMuted,
                                border: Color.clear
                            ),
                            properties: DSStateProperties(
                                isUnderlined: false,
                                hasSecondaryFocusRing: false,
                                scale: 1)
                        )
                    )
                    
                }
            }
            
            public enum Primary {
                // FILLED BUTTON CONFIG
                public static let filledConfig = DSButtonStateStyleConfig(
                    normal: .init(
                        colorStyle: DSButtonStateColorStyle(
                            background: DSColors.colorThemePrimaryBg,
                            foreground: DSColors.colorThemePrimaryFill,
                            border: Color.clear
                        ),
                        properties: DSStateProperties(
                            isUnderlined: false,
                            hasSecondaryFocusRing: false,
                            scale: 1)
                    ),
                    hovered: .init(
                        colorStyle: DSButtonStateColorStyle(
                            background: DSColors.colorThemePrimaryBgHover,
                            foreground: DSColors.colorThemePrimaryFillHover,
                            border: Color.clear
                        ),
                        properties: DSStateProperties(
                            isUnderlined: false,
                            hasSecondaryFocusRing: false,
                            scale: 1)
                    ),
                    pressed: .init(
                        colorStyle: DSButtonStateColorStyle(
                            background: DSColors.colorThemePrimaryBgActive,
                            foreground: DSColors.colorThemePrimaryFillActive,
                            border: Color.clear
                        ),
                        properties: DSStateProperties(
                            isUnderlined: false,
                            hasSecondaryFocusRing: false,
                            scale: 1)
                    ),
                    focused: .init(
                        colorStyle: DSButtonStateColorStyle(
                            background: DSColors.colorThemePrimaryBg,
                            foreground: DSColors.colorThemePrimaryFill,
                            border: Color.clear
                        ),
                        properties: DSStateProperties(
                            isUnderlined: false,
                            hasSecondaryFocusRing: true,
                            scale: 1)
                    ),
                    disabled: .init(
                        colorStyle: DSButtonStateColorStyle(
                            background: DSColors.colorUiBackgroundMuted,
                            foreground: DSColors.colorUiFontMuted,
                            border: Color.clear
                        ),
                        properties: DSStateProperties(
                            isUnderlined: false,
                            hasSecondaryFocusRing: false,
                            scale: 1)
                    )
                )
                
                public static let borderConfig = DSButtonStateStyleConfig(
                    normal: .init(
                        colorStyle: DSButtonStateColorStyle(
                            background: Color.clear,
                            foreground: DSColors.colorThemePrimaryText,
                            border: DSColors.colorThemePrimaryBg
                        ),
                        properties: DSStateProperties(
                            isUnderlined: false,
                            hasSecondaryFocusRing: false,
                            scale: 1)
                    ),
                    hovered: .init(
                        colorStyle: DSButtonStateColorStyle(
                            background: DSColors.colorThemePrimaryBgHover,
                            foreground: DSColors.colorThemePrimaryText,
                            border: DSColors.colorThemePrimaryBg
                        ),
                        properties: DSStateProperties(
                            isUnderlined: false,
                            hasSecondaryFocusRing: false,
                            scale: 1)
                    ),
                    pressed: .init(
                        colorStyle: DSButtonStateColorStyle(
                            background: DSColors.colorThemePrimaryBgActive,
                            foreground: DSColors.colorThemePrimaryText,
                            border: DSColors.colorThemePrimaryBg
                        ),
                        properties: DSStateProperties(
                            isUnderlined: false,
                            hasSecondaryFocusRing: false,
                            scale: 1)
                    ),
                    focused: .init(
                        colorStyle: DSButtonStateColorStyle(
                            background: Color.clear,
                            foreground: DSColors.colorThemePrimaryText,
                            border: DSColors.colorThemePrimaryBg
                        ),
                        properties: DSStateProperties(
                            isUnderlined: false,
                            hasSecondaryFocusRing: true,
                            scale: 1)
                    ),
                    disabled: .init(
                        colorStyle: DSButtonStateColorStyle(
                            background: Color.clear,
                            foreground: DSColors.colorUiFontMuted,
                            border: DSColors.colorUiFontMuted
                        ),
                        properties: DSStateProperties(
                            isUnderlined: false,
                            hasSecondaryFocusRing: false,
                            scale: 1)
                    )
                )
                
                public static let ghostConfig = DSButtonStateStyleConfig(
                    normal: .init(
                        colorStyle: DSButtonStateColorStyle(
                            background: Color.clear,
                            foreground: DSColors.colorThemePrimaryText,
                            border: Color.clear
                        ),
                        properties: DSStateProperties(
                            isUnderlined: false,
                            hasSecondaryFocusRing: false,
                            scale: 1)
                    ),
                    hovered: .init(
                        colorStyle: DSButtonStateColorStyle(
                            background: DSColors.colorThemePrimaryBgHover,
                            foreground: DSColors.colorThemePrimaryText,
                            border: Color.clear
                        ),
                        properties: DSStateProperties(
                            isUnderlined: false,
                            hasSecondaryFocusRing: false,
                            scale: 1)
                    ),
                    pressed: .init(
                        colorStyle: DSButtonStateColorStyle(
                            background: DSColors.colorThemePrimaryBgActive,
                            foreground: DSColors.colorThemePrimaryText,
                            border: Color.clear
                        ),
                        properties: DSStateProperties(
                            isUnderlined: false,
                            hasSecondaryFocusRing: false,
                            scale: 1)
                    ),
                    focused: .init(
                        colorStyle: DSButtonStateColorStyle(
                            background: Color.clear,
                            foreground: DSColors.colorThemePrimaryText,
                            border: Color.clear
                        ),
                        properties: DSStateProperties(
                            isUnderlined: false,
                            hasSecondaryFocusRing: true,
                            scale: 1)
                    ),
                    disabled: .init(
                        colorStyle: DSButtonStateColorStyle(
                            background: Color.clear,
                            foreground: DSColors.colorUiFontMuted,
                            border: Color.clear
                        ),
                        properties: DSStateProperties(
                            isUnderlined: false,
                            hasSecondaryFocusRing: false,
                            scale: 1)
                    )
                )
                
                public static let linkConfig = DSButtonStateStyleConfig(
                    normal: .init(
                        colorStyle: DSButtonStateColorStyle(
                            background: Color.clear,
                            foreground: DSColors.colorThemePrimaryText,
                            border: Color.clear
                        ),
                        properties: DSStateProperties(
                            isUnderlined: true,
                            hasSecondaryFocusRing: true,
                            scale: 1)
                    ),
                    hovered: .init(
                        colorStyle: DSButtonStateColorStyle(
                            background: Color.clear,
                            foreground: DSColors.colorThemePrimaryText,
                            border: Color.clear
                        ),
                        properties: DSStateProperties(
                            isUnderlined: true,
                            hasSecondaryFocusRing: false,
                            scale: 1)
                    ),
                    pressed: .init(
                        colorStyle: DSButtonStateColorStyle(
                            background: Color.clear,
                            foreground: DSColors.colorThemePrimaryText,
                            border: Color.clear
                        ),
                        properties: DSStateProperties(
                            isUnderlined: true,
                            hasSecondaryFocusRing: false,
                            scale: 1)
                    ),
                    focused: .init(
                        colorStyle: DSButtonStateColorStyle(
                            background: Color.clear,
                            foreground: DSColors.colorThemePrimaryText,
                            border: Color.clear
                        ),
                        properties: DSStateProperties(
                            isUnderlined: false,
                            hasSecondaryFocusRing: true,
                            scale: 1)
                    ),
                    disabled: .init(
                        colorStyle: DSButtonStateColorStyle(
                            background: Color.clear,
                            foreground: DSColors.colorUiFontMuted,
                            border: Color.clear
                        ),
                        properties: DSStateProperties(
                            isUnderlined: false,
                            hasSecondaryFocusRing: false,
                            scale: 1)
                    )
                )
            }
        }
    }
}

