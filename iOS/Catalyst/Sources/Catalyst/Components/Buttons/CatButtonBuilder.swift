//
//  CatButton.swift
//  Catalyst
//
//  Created by Efe Durmaz on 24.11.25.
//

import SwiftUI

public struct CatButton: View {
    let content: CatButtonContent
    let buttonSize: CatButtonSize
    let styleConfig: CatButtonStateStyleConfig?
    let styleFont: Font?
    let stackSpacing: CGFloat?
    let padding: EdgeInsets?
    let action: () -> Void
    
    public init(_ content: CatButtonContent,
                buttonSize: CatButtonSize = .small,
                styleConfig: CatButtonStateStyleConfig? = CatTheme.Components.Buttons.Primary.filledConfig,
                styleFont: Font? = CatTypography.s1,
                stackSpacing: CGFloat? = nil,
                padding: EdgeInsets? = nil, action: @escaping () -> Void) {
        self.content = content
        self.buttonSize = buttonSize
        self.styleConfig = styleConfig
        self.styleFont = styleFont
        self.stackSpacing = stackSpacing
        self.padding = padding
        self.action = action
    }
    
    public var body: some View {
        CatButtonBuilder(content: content,
                 buttonSize: buttonSize,
                 iconSize: .init(width: CatSizes.sizeLg, height: CatSizes.sizeLg),
                 stackSpacing: stackSpacing,
                 action: action)
            .buttonStyle(
                CatButtonStyle(
                    styleConfig: styleConfig ?? CatTheme.Components.Buttons.Primary.filledConfig,
                    font: styleFont ?? CatTypography.s1,
                    borderWidth: CatBorderWidth.borderWidthThin,
                    cornerRadius: CatBorderRadius.borderRadiusMd,
                    padding: padding ??  EdgeInsets(
                        top: CatSpacing.spacingLg,
                        leading: CatSpacing.spacingXl,
                        bottom: CatSpacing.spacingLg,
                        trailing: CatSpacing.spacingXl
                    )
                )
            )
    }
}

public struct EngageKudosButton: View {
    let content: CatButtonContent
    let action: () -> Void
    
    public init(_ content: CatButtonContent, action: @escaping () -> Void) {
        self.content = content
        self.action = action
    }
    
    public var body: some View {
        CatButtonBuilder(content: content, iconSize: .init(width: CatSizes.sizeXl, height: CatSizes.sizeXl), action: action)
            .buttonStyle(
                CatButtonStyle(
                    styleConfig: CatTheme.Components.Buttons.Primary.filledConfig,
                    font: CatTypography.body1,
                    borderWidth: CatBorderWidth.borderWidthThin,
                    cornerRadius: CatBorderRadius.borderRadiusSm,
                    padding: EdgeInsets(
                        top: CatSpacing.spacing3xl,
                        leading: CatSpacing.spacingMd,
                        bottom: CatSpacing.spacing3xl,
                        trailing: CatSpacing.spacingMd
                    )
                )
            )
            .padding(CatSpacing.spacingMd)
    }
}
