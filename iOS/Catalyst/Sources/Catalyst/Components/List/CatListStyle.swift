//
//  SwiftUIView.swift
//  Catalyst
//
//  Created by Efe Durmaz on 04.05.26.
//

import SwiftUI

// MARK: - List Properties
public struct CatListColorStyle: Sendable {
    let background: Color
    let foreground: Color
    let border: Color
    
    public init(background: Color, foreground: Color, border: Color) {
        self.background = background
        self.foreground = foreground
        self.border = border
    }
}

// The Ellipse indicates there are new items within given list element
public struct CatListProperties: Sendable {
    let hasEllipse: Bool?
    
    public init(
        hasEllipse: Bool? = nil
    ) {
        self.hasEllipse = hasEllipse
    }
}

// Combined State Control over CatListStateColorStyle & CatListnStateColorStyle will be provided to CatListStateStyleConfig
public struct CatListStateStyle: Sendable {
    public let colorStyle: CatListColorStyle
    public let properties: CatListProperties?
    
    public init(colorStyle: CatListColorStyle,
                properties: CatListProperties? = nil) {
        self.colorStyle = colorStyle
        self.properties = properties
    }
}

public struct CatListStateStyleConfig: Sendable {
    let normal: CatListStateStyle
    let hovered: CatListStateStyle?
    let pressed: CatListStateStyle
    let focused: CatListStateStyle
    let disabled: CatListStateStyle
    let loading: CatListStateStyle?
    
    public init(
        normal: CatListStateStyle,
        hovered: CatListStateStyle? = nil,
        pressed: CatListStateStyle,
        focused: CatListStateStyle,
        disabled: CatListStateStyle,
        loading: CatListStateStyle? = nil
    ) {
        self.normal = normal
        self.hovered = hovered
        self.pressed = pressed
        self.focused = focused
        self.disabled = disabled
        self.loading = loading
    }
}

public enum CatListSize {
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

public enum CatListContent {
    case listItem(icon: Image, title: String, newItemIndicator: Bool?)
    case specialWithSubtitle(icon: Image, title: String, subtitle: String, newItemIndicator: Bool?)
}

// MARK: - List styling
public struct CatListStyle: ButtonStyle {
    let styleConfig: CatListStateStyleConfig
    let font: Font
    let borderWidth: CGFloat
    let cornerRadius: CGFloat
    let padding: EdgeInsets
    let listItemSize: CatListSize
    
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
            .frame(height: listItemSize.height)
            .background(state.colorStyle.background)
            .foregroundStyle(state.colorStyle.foreground)
            .overlay(RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(state.colorStyle.border, lineWidth: borderWidth))
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
//            .scaleEffect(state.properties?.scale ?? 1) // Scale effect added for experimenting
//            .animation(.spring(response: 0.2, dampingFraction: 0.8), value: state)
            .onHover { hovering in
                isHovered = hovering
            }
            .contentShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
    
    private func resolveState(isPressed: Bool) -> CatListStateStyle {
        guard isEnabled else { return styleConfig.disabled }
        if isLoading {
            return styleConfig.loading ?? styleConfig.normal
        } else if isPressed {
            return styleConfig.pressed
        } else if isHovered, let hovered = styleConfig.hovered {
            return hovered
        } else if isFocused {
            return styleConfig.focused
        } else { return styleConfig.normal
        }
    }
}
