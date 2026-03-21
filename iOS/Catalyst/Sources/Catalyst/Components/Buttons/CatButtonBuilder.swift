//
//  CatButtonBuilder.swift
//  Catalyst
//
//  Created by Efe Durmaz on 24.11.25.
//

import SwiftUI

// MARK: - Button Layout

/// Internal layout helper. Builds the visual content of a `CatButton`
/// based on the provided `CatButtonContent` model.
public struct CatButtonBuilder: View {
    let content: CatButtonContent
    let action: () -> Void
    let iconSize: CGSize?
    let stackSpacing: CGFloat?

    public init(
        content: CatButtonContent,
        iconSize: CGSize? = CGSize(width: CatSizes.sizeSm, height: CatSizes.sizeSm),
        stackSpacing: CGFloat? = CatSpacing.spacingMd,
        action: @escaping () -> Void
    ) {
        self.content = content
        self.iconSize = iconSize
        self.action = action
        self.stackSpacing = stackSpacing
    }

    public var body: some View {
        Button(action: action) {
            buildContent()
        }
    }

    @ViewBuilder
    private func buildContent() -> some View {
        switch content {
        case .text(let title):
            Text(title)
        case .icon(let img):
            iconView(img)
        case .iconText(let icon, let title, let placement):
            switch placement {
            case .leading:
                HStack(alignment: .center, spacing: stackSpacing) {
                    iconView(icon)
                    Text(title)
                }
                .multilineTextAlignment(.center)
            case .trailing:
                HStack(alignment: .center, spacing: stackSpacing) {
                    Text(title)
                    iconView(icon)
                }
                .multilineTextAlignment(.center)
            case .top:
                VStack(spacing: stackSpacing) {
                    iconView(icon)
                    Text(title)
                }
            case .bottom:
                VStack(spacing: stackSpacing) {
                    Text(title)
                    iconView(icon)
                }
            }
        }
    }

    private func iconView(_ icon: Image) -> some View {
        icon.resizable()
            .renderingMode(.template)
            .scaledToFit()
            .frame(width: iconSize?.width ?? CatSizes.sizeSm, height: iconSize?.height ?? CatSizes.sizeSm)
    }
}

// MARK: - CatButton (Public View)

public struct CatButton: View {
    let content: CatButtonContent
    let buttonSize: CatButtonSize
    let styleFont: Font?
    let stackSpacing: CGFloat?
    let padding: EdgeInsets?
    let action: () -> Void

    /// Creates a `CatButton`.
    ///
    /// - Parameters:
    ///   - content: The button's visual content (text, icon, or icon+text).
    ///   - buttonSize: The sizing preset for the button.
    ///   - styleFont: Overrides the default button label font.
    ///   - stackSpacing: Overrides the spacing between icon and label.
    ///   - padding: Overrides the default internal padding.
    ///   - action: The closure invoked when the button is tapped.
    public init(
        _ content: CatButtonContent,
        buttonSize: CatButtonSize = .medium,
        styleFont: Font? = nil,
        stackSpacing: CGFloat? = nil,
        padding: EdgeInsets? = nil,
        action: @escaping () -> Void
    ) {
        self.content = content
        self.buttonSize = buttonSize
        self.styleFont = styleFont
        self.stackSpacing = stackSpacing
        self.padding = padding
        self.action = action
    }

    /// The active button config from the environment. Set via `.catButtonConfig(variant:color:)`.
    @Environment(\.catButtonConfig) private var buttonConfig
    /// The active Catalyst theme from the environment. Passed through to the palette registry
    /// so a `.catalystTheme(.dark)` modifier higher in the hierarchy is respected automatically.
    @Environment(\.catalystTheme) private var theme
    /// An optional accent palette injected via `.catalystAccentColor(_:)`. When present and the
    /// button's color role is `.primary` (the default), this palette overrides the registry entry
    /// so the button renders in the client's brand color across all variants.
    @Environment(\.catalystAccentPalette) private var accentPalette

    public var body: some View {
        CatButtonBuilder(
            content: content,
            iconSize: .init(width: CatSizes.sizeLg, height: CatSizes.sizeLg),
            stackSpacing: stackSpacing,
            action: action
        )
        .buttonStyle(
            CatButtonStyle(
                styleConfig: CatTheme.buttonConfig(
                    variant: buttonConfig.variant,
                    color: buttonConfig.color,
                    theme: theme,
                    accentPalette: accentPalette
                ),
                font: styleFont ?? {
                    switch buttonConfig.variant {
                    case .filled: return CatTypography.button1
                    case .outlined, .text, .link: return CatTypography.button2
                    }
                }(),
                borderWidth: CatBorderWidth.borderWidthThin,
                cornerRadius: CatBorderRadius.borderRadiusMd,
                padding: padding ?? EdgeInsets(
                    top: CatSpacing.spacingLg,
                    leading: CatSpacing.spacingXl,
                    bottom: CatSpacing.spacingLg,
                    trailing: CatSpacing.spacingXl
                ),
                buttonSize: buttonSize
            )
        )
    }
}
