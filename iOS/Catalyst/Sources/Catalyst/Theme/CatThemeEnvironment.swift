//
//  CatThemeEnvironment.swift
//  Catalyst
//
//  Created by Efe Durmaz on 27.02.26.
//

import SwiftUI

// MARK: - Theme environment

private struct CatThemeEnvironmentKey: EnvironmentKey {
    static let defaultValue: CatTheme.ThemeType = .primaryHaiilo
}

public extension EnvironmentValues {
    var catalystTheme: CatTheme.ThemeType {
        get { self[CatThemeEnvironmentKey.self] }
        set { self[CatThemeEnvironmentKey.self] = newValue }
    }
}

public extension View {
    /// Injects a Catalyst theme into the SwiftUI environment for all descendant views.
    func catalystTheme(_ theme: CatTheme.ThemeType) -> some View {
        environment(\.catalystTheme, theme)
    }
}

// MARK: - Button config environment

/// A lightweight value that describes the visual appearance of a `CatButton` via its
/// semantic `variant` and `color` role. Inject it with `.catButtonConfig(variant:color:)`.
///
/// ```swift
/// CatButton(.text("Delete")) { }
///     .catButtonConfig(variant: .filled, color: .danger)
///
/// // Applied to a group — all CatButtons inside inherit the config:
/// VStack {
///     CatButton(.text("Confirm")) { }
///     CatButton(.text("Cancel")) { }
/// }
/// .catButtonConfig(variant: .outlined, color: .primary)
/// ```
public struct CatButtonConfig: Equatable {
    public var variant: CatTheme.ButtonVariant
    public var color: CatTheme.ColorConfig

    public init(variant: CatTheme.ButtonVariant = .filled, color: CatTheme.ColorConfig = .primary) {
        self.variant = variant
        self.color = color
    }

    /// The default config: `.filled` variant with `.primary` color.
    public static let `default` = CatButtonConfig(variant: .filled, color: .primary)
}

private struct CatButtonConfigEnvironmentKey: EnvironmentKey {
    static let defaultValue: CatButtonConfig = .default
}

public extension EnvironmentValues {
    /// The active `CatButtonConfig` for descendant `CatButton` views.
    /// Set via `.catButtonConfig(variant:color:)`.
    var catButtonConfig: CatButtonConfig {
        get { self[CatButtonConfigEnvironmentKey.self] }
        set { self[CatButtonConfigEnvironmentKey.self] = newValue }
    }
}

public extension View {
    /// Sets the button variant and color role for all `CatButton` views in this subtree.
    ///
    /// This modifier injects a `CatButtonConfig` into the SwiftUI environment. Any `CatButton`
    /// that does not have an explicit `styleConfig` parameter will resolve its colors from this
    /// environment value via `CatTheme.buttonConfig(variant:color:)`.
    ///
    /// - Parameters:
    ///   - variant: The visual shape — `.filled`, `.outlined`, `.text`, or `.link`.
    ///   - color: The semantic color role — `.primary`, `.danger`, `.success`, etc.
    func catButtonConfig(variant: CatTheme.ButtonVariant, color: CatTheme.ColorConfig) -> some View {
        environment(\.catButtonConfig, CatButtonConfig(variant: variant, color: color))
    }
}
