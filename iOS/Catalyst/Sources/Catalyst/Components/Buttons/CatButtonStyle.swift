//
//  CatButton.swift
//  Catalyst
//
//  Created by Efe Durmaz on 24.11.25.
//

import SwiftUI

// MARK: - Button Properties

public struct CatButtonStateColorStyle: Sendable {
    let background: Color
    let foreground: Color
    let border: Color
    
    public init(background: Color, foreground: Color, border: Color) {
        self.background = background
        self.foreground = foreground
        self.border = border
    }
}

// The Visual Properties, "toggles" for structural changes.
public struct CatStateProperties: Sendable {
    let isUnderlined: Bool?
    let hasSecondaryFocusRing: Bool?
    let scale: CGFloat? // e.g., 0.95 on press
    
    public init(
        isUnderlined: Bool? = nil,
        hasSecondaryFocusRing: Bool? = nil,
        scale: CGFloat? = nil
    ) {
        self.isUnderlined = isUnderlined
        self.hasSecondaryFocusRing = hasSecondaryFocusRing
        self.scale = scale
    }
}

public struct CatButtonStateStyle: Sendable {
    public let colorStyle: CatButtonStateColorStyle
    public let properties: CatStateProperties?
    
    public init(colorStyle: CatButtonStateColorStyle,
                properties: CatStateProperties? = nil) {
        self.colorStyle = colorStyle
        self.properties = properties
    }
}

public struct CatButtonStateStyleConfig: Sendable {
    let normal: CatButtonStateStyle
    let hovered: CatButtonStateStyle?
    let pressed: CatButtonStateStyle
    let focused: CatButtonStateStyle
    let disabled: CatButtonStateStyle
    let loading: CatButtonStateStyle?
    
    public init(
        normal: CatButtonStateStyle,
        hovered: CatButtonStateStyle? = nil,
        pressed: CatButtonStateStyle,
        focused: CatButtonStateStyle,
        disabled: CatButtonStateStyle,
        loading: CatButtonStateStyle? = nil
    ) {
        self.normal = normal
        self.hovered = hovered
        self.pressed = pressed
        self.focused = focused
        self.disabled = disabled
        self.loading = loading
    }
}

public enum CatButtonSize {
    case extraSmall
    case small
    case medium
    case custom(CGFloat)
    
    var height: CGFloat {
        switch self {
        case .extraSmall: return CatSizes.sizeXl
        case .small: return CatSizes.size2xl
        case .medium: return CatSizes.size3xl
        case .custom(let height): return height
        }
    }
}

public enum CatButtonContent {
    case text(String)
    case icon(Image)
    case iconText(icon: Image, text: String, placement: Placement)

    public enum Placement {
        case leading
        case trailing
        case top
        case bottom
    }
}

// MARK: - Button styling

public struct CatButtonStyle: ButtonStyle {
    
    let styleConfig: CatButtonStateStyleConfig
    let font: Font
    let borderWidth: CGFloat
    let cornerRadius: CGFloat
    let padding: EdgeInsets
    let buttonSize: CatButtonSize
    
    var isLoading: Bool = false
    @State var isHovered: Bool = false
    @Environment(\.isFocused) private var isFocused
    @Environment(\.isEnabled) private var isEnabled
    
    public func makeBody(configuration: Configuration) -> some View {
        let state = resolveState(isPressed: configuration.isPressed)
        
        configuration.label
            .font(font)
            .padding(padding)
            .frame(minWidth: 44,
                   maxWidth: .infinity
            )
            .frame(height: buttonSize.height)
            .underline(state.properties?.isUnderlined == true)
            .background(state.colorStyle.background)
            .foregroundStyle(state.colorStyle.foreground)
            .overlay(RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(state.colorStyle.border, lineWidth: borderWidth))
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .overlay(
                Group {
                    if (state.properties?.hasSecondaryFocusRing == true) {
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(
                                CatColors.colorUiBorderFocus,
                                lineWidth: CatBorderWidth.borderWidthThin)
                            .padding(-CatSpacing.spacingXxs)
                    }
                }
            )
//            .scaleEffect(state.properties?.scale ?? 1) // Scale effect added for experimenting
//            .animation(.spring(response: 0.2, dampingFraction: 0.8), value: state)
            .onHover { hovering in
                isHovered = hovering
            }
            .contentShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
    
    private func resolveState(isPressed: Bool) -> CatButtonStateStyle {
        guard isEnabled else { return styleConfig.disabled }
        if isLoading { return styleConfig.loading ?? styleConfig.normal }
        else if isPressed { return styleConfig.pressed }
        else if isHovered, let hovered = styleConfig.hovered {
            return hovered
        }
        else if isFocused { return styleConfig.focused }
        else { return styleConfig.normal }
    }
}

// MARK: - Button Layout
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
                HStack(spacing: stackSpacing) {
                    iconView(icon)
                    Text(title)
                }
            case .trailing:
                HStack(spacing: stackSpacing) {
                    Text(title)
                    iconView(icon)
                }
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
