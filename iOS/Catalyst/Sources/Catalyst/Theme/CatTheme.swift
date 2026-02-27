//
//  CatTheme.swift
//  Catalyst
//
//  Created by Efe Durmaz on 21.11.25.
//

import SwiftUI

public enum CatTheme {
    // MARK: - Theme Type
    /// Represents the available Catalyst themes.
    /// Currently only `.primaryHaiilo` is supported; additional cases can be added in future releases.
    public enum ThemeType {
        case primaryHaiilo
    }
    
    /// The theme that was selected during `configure(theme:)`. Defaults to `.primaryHaiilo`.
    public static private(set) var current: ThemeType = .primaryHaiilo
    
    // MARK: - Configuration
    /// - Parameter theme: The theme to activate. Defaults to `.primaryHaiilo`.
    public static func configure(theme: ThemeType = .primaryHaiilo) {
        current = theme
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
                                foreground: CatColors.Theme.Primary.fill,
                                border: Color.clear),
                            properties: CatStateProperties(
                                isUnderlined: false,
                                hasSecondaryFocusRing: false,
                                scale: 1)
                        ),
                        hovered: .init(
                            colorStyle: CatButtonStateColorStyle(
                                background: accentColor.darken(by: AccentColorDarkenFactor.hovered.rawValue),
                                foreground: CatColors.Theme.Primary.fillHover,
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
                                foreground: CatColors.Theme.Primary.fillActive,
                                border: Color.clear),
                            properties: CatStateProperties(
                                isUnderlined: false,
                                hasSecondaryFocusRing: false,
                                scale: 1)
                        ),
                        focused: .init(
                            colorStyle: CatButtonStateColorStyle(
                                background: accentColor,
                                foreground: CatColors.Theme.Primary.fill,
                                border: Color.clear),
                            properties: CatStateProperties(
                                isUnderlined: false,
                                hasSecondaryFocusRing: true,
                                scale: 1)
                        ),
                        disabled: .init(
                            colorStyle: CatButtonStateColorStyle(
                                background: CatColors.Ui.Background.muted,
                                foreground: CatColors.Ui.Font.muted,
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
                                background: CatColors.Theme.Primary.bgHover,
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
                                background: CatColors.Theme.Primary.bgActive,
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
                                foreground: CatColors.Ui.Font.muted,
                                border: CatColors.Ui.Font.muted
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
                                background: CatColors.Theme.Primary.bgHover,
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
                                background: CatColors.Theme.Primary.bgActive,
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
                                foreground: CatColors.Ui.Font.muted,
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
                                foreground: CatColors.Ui.Font.muted,
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
                            background: CatColors.Theme.Primary.bg,
                            foreground: CatColors.Theme.Primary.fill,
                            border: Color.clear
                        ),
                        properties: CatStateProperties(
                            isUnderlined: false,
                            hasSecondaryFocusRing: false,
                            scale: 1)
                    ),
                    hovered: .init(
                        colorStyle: CatButtonStateColorStyle(
                            background: CatColors.Theme.Primary.bgHover,
                            foreground: CatColors.Theme.Primary.fillHover,
                            border: Color.clear
                        ),
                        properties: CatStateProperties(
                            isUnderlined: false,
                            hasSecondaryFocusRing: false,
                            scale: 1)
                    ),
                    pressed: .init(
                        colorStyle: CatButtonStateColorStyle(
                            background: CatColors.Theme.Primary.bgActive,
                            foreground: CatColors.Theme.Primary.fillActive,
                            border: Color.clear
                        ),
                        properties: CatStateProperties(
                            isUnderlined: false,
                            hasSecondaryFocusRing: false,
                            scale: 1)
                    ),
                    focused: .init(
                        colorStyle: CatButtonStateColorStyle(
                            background: CatColors.Theme.Primary.bg,
                            foreground: CatColors.Theme.Primary.fill,
                            border: Color.clear
                        ),
                        properties: CatStateProperties(
                            isUnderlined: false,
                            hasSecondaryFocusRing: true,
                            scale: 1)
                    ),
                    disabled: .init(
                        colorStyle: CatButtonStateColorStyle(
                            background: CatColors.Ui.Background.muted,
                            foreground: CatColors.Ui.Font.muted,
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
                            foreground: CatColors.Theme.Primary.text,
                            border: CatColors.Theme.Primary.bg
                        ),
                        properties: CatStateProperties(
                            isUnderlined: false,
                            hasSecondaryFocusRing: false,
                            scale: 1)
                    ),
                    hovered: .init(
                        colorStyle: CatButtonStateColorStyle(
                            background: CatColors.Theme.Primary.bgHover,
                            foreground: CatColors.Theme.Primary.text,
                            border: CatColors.Theme.Primary.bg
                        ),
                        properties: CatStateProperties(
                            isUnderlined: false,
                            hasSecondaryFocusRing: false,
                            scale: 1)
                    ),
                    pressed: .init(
                        colorStyle: CatButtonStateColorStyle(
                            background: CatColors.Theme.Primary.bgActive,
                            foreground: CatColors.Theme.Primary.text,
                            border: CatColors.Theme.Primary.bg
                        ),
                        properties: CatStateProperties(
                            isUnderlined: false,
                            hasSecondaryFocusRing: false,
                            scale: 1)
                    ),
                    focused: .init(
                        colorStyle: CatButtonStateColorStyle(
                            background: Color.clear,
                            foreground: CatColors.Theme.Primary.text,
                            border: CatColors.Theme.Primary.bg
                        ),
                        properties: CatStateProperties(
                            isUnderlined: false,
                            hasSecondaryFocusRing: true,
                            scale: 1)
                    ),
                    disabled: .init(
                        colorStyle: CatButtonStateColorStyle(
                            background: Color.clear,
                            foreground: CatColors.Ui.Font.muted,
                            border: CatColors.Ui.Font.muted
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
                            foreground: CatColors.Theme.Primary.text,
                            border: Color.clear
                        ),
                        properties: CatStateProperties(
                            isUnderlined: false,
                            hasSecondaryFocusRing: false,
                            scale: 1)
                    ),
                    hovered: .init(
                        colorStyle: CatButtonStateColorStyle(
                            background: CatColors.Theme.Primary.bgHover,
                            foreground: CatColors.Theme.Primary.text,
                            border: Color.clear
                        ),
                        properties: CatStateProperties(
                            isUnderlined: false,
                            hasSecondaryFocusRing: false,
                            scale: 1)
                    ),
                    pressed: .init(
                        colorStyle: CatButtonStateColorStyle(
                            background: CatColors.Theme.Primary.bgActive,
                            foreground: CatColors.Theme.Primary.text,
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
                            foreground: CatColors.Theme.Primary.text,
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
                            foreground: CatColors.Ui.Font.muted,
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
                            foreground: CatColors.Theme.Primary.text,
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
                            foreground: CatColors.Theme.Primary.text,
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
                            foreground: CatColors.Theme.Primary.text,
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
                            foreground: CatColors.Theme.Primary.text,
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
                            foreground: CatColors.Ui.Font.muted,
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
