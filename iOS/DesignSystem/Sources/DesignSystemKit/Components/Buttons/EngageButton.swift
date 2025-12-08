//
//  EngageButton.swift
//  DesignSystemKit
//
//  Created by Efe Durmaz on 24.11.25.
//

import SwiftUI

public struct EngageButton: View {
    let content: DSButtonContent
    let buttonSize: DSButtonSize
    let styleConfig: DSButtonStateStyleConfig?
    let stackSpacing: CGFloat?
    let padding: EdgeInsets?
    let action: () -> Void
    
    public init(_ content: DSButtonContent,
                buttonSize: DSButtonSize = .small,
                styleConfig: DSButtonStateStyleConfig? = DSTheme.Components.Buttons.Primary.filledConfig,
                stackSpacing: CGFloat? = nil,
                padding: EdgeInsets? = nil, action: @escaping () -> Void) {
        self.content = content
        self.buttonSize = buttonSize
        self.styleConfig = styleConfig
        self.stackSpacing = stackSpacing
        self.padding = padding
        self.action = action
    }
    
    public var body: some View {
        DSButton(content: content,
                 buttonSize: buttonSize,
                 iconSize: .init(width: DSSizes.sizeLg, height: DSSizes.sizeLg),
                 stackSpacing: stackSpacing,
                 action: action)
            .buttonStyle(
                DSButtonStyle(
                    styleConfig: styleConfig ?? DSTheme.Components.Buttons.Primary.filledConfig,
                    font: DSTypography.s1,
                    borderWidth: DSBorderWidth.borderWidthThin,
                    cornerRadius: DSBorderRadius.borderRadiusMd,
                    padding: padding ??  EdgeInsets(
                        top: DSSpacing.spacingLg,
                        leading: DSSpacing.spacingXl,
                        bottom: DSSpacing.spacingLg,
                        trailing: DSSpacing.spacingXl
                    )
                )
            )
    }
}

public struct EngageKudosButton: View {
    let content: DSButtonContent
    let action: () -> Void
    
    public init(_ content: DSButtonContent, action: @escaping () -> Void) {
        self.content = content
        self.action = action
    }
    
    public var body: some View {
        DSButton(content: content, iconSize: .init(width: DSSizes.sizeXl, height: DSSizes.sizeXl), action: action)
            .buttonStyle(
                DSButtonStyle(
                    styleConfig: DSTheme.Components.Buttons.Primary.filledConfig,
                    font: DSTypography.body1,
                    borderWidth: DSBorderWidth.borderWidthThin,
                    cornerRadius: DSBorderRadius.borderRadiusSm,
                    padding: EdgeInsets(
                        top: DSSpacing.spacing3xl,
                        leading: DSSpacing.spacingMd,
                        bottom: DSSpacing.spacing3xl,
                        trailing: DSSpacing.spacingMd
                    )
                )
            )
            .padding(DSSpacing.spacingMd)
    }
}
