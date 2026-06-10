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

// MARK: - Alert config environment

/// A lightweight value that describes the appearance of a `CatAlert` via its semantic `variant`.
/// Inject it with `.catAlertConfig(variant:)`.
///
/// ```swift
/// CatAlert("Saved successfully") {
///     CatButton(.text("Undo"), buttonSize: .small) { }
/// }
/// .catAlertConfig(variant: .success)
///
/// // Applied to a group — all CatAlerts inside inherit the variant:
/// VStack {
///     CatAlert("First")
///     CatAlert("Second")
/// }
/// .catAlertConfig(variant: .info)
/// ```
public struct CatAlertConfig: Equatable {
    public var variant: CatAlertVariant

    public init(variant: CatAlertVariant = .info) {
        self.variant = variant
    }
}

private struct CatAlertConfigEnvironmentKey: EnvironmentKey {
    static let defaultValue = CatAlertConfig(variant: .info)
}

public extension EnvironmentValues {
    /// The active `CatAlertConfig` for descendant `CatAlert` views.
    /// Set via `.catAlertConfig(variant:)`.
    var catAlertConfig: CatAlertConfig {
        get { self[CatAlertConfigEnvironmentKey.self] }
        set { self[CatAlertConfigEnvironmentKey.self] = newValue }
    }
}

public extension View {
    /// Sets the alert variant for all `CatAlert` views in this subtree.
    ///
    /// This modifier injects a `CatAlertConfig` into the SwiftUI environment. Any `CatAlert`
    /// resolves its colors from this environment value via `CatTheme.alertConfig(variant:)`.
    ///
    /// - Parameter variant: The semantic color role — `.info`, `.success`, `.warning`,
    ///   `.danger`, `.neutral`, or `.brand`.
    func catAlertConfig(variant: CatAlertVariant) -> some View {
        environment(\.catAlertConfig, CatAlertConfig(variant: variant))
    }
}

// MARK: - Accent color environment

private struct CatAccentPaletteEnvironmentKey: EnvironmentKey {
    static let defaultValue: CatColorPalette? = nil
}

public extension EnvironmentValues {
    /// An optional `CatColorPalette` derived from a custom brand/accent color.
    ///
    /// When present, it overrides the `.primary` palette in `CatTheme.buttonConfig` so that
    /// all `CatButton` views using `color: .primary` (the default) render in the client's
    /// brand color. Buttons using other color roles (`.danger`, `.secondary`, etc.) are
    /// unaffected. Set via `.catalystAccentColor(_:)`.
    var catalystAccentPalette: CatColorPalette? {
        get { self[CatAccentPaletteEnvironmentKey.self] }
        set { self[CatAccentPaletteEnvironmentKey.self] = newValue }
    }
}

public extension View {
    /// Injects a custom brand/accent color into this subtree.
    ///
    /// All `CatButton` views that use the default `color: .primary` role will render using
    /// this color across all four variants (`.filled`, `.outlined`, `.text`, `.link`).
    /// Hover and pressed states are derived automatically via `CatTheme.AccentColorDarkenFactor`.
    /// Buttons using other color roles (`.danger`, `.secondary`, etc.) are unaffected.
    ///
    /// ```swift
    /// // Whitelabeling — set once at the root, every primary button picks it up:
    /// ContentView()
    ///     .catalystAccentColor(client.brandColor)
    ///
    /// // Mixed usage — some buttons use the brand color, others don't:
    /// VStack {
    ///     CatButton(.text("Confirm")) { }           // .primary by default → brand color
    ///     CatButton(.text("Delete")) { }
    ///         .catButtonConfig(variant: .filled, color: .danger)  // unaffected
    /// }
    /// .catalystAccentColor(brandColor)
    /// ```
    ///
    /// - Parameter color: The brand `Color` to use as the primary palette base.
    func catalystAccentColor(_ color: Color) -> some View {
        environment(\.catalystAccentPalette, CatColorPalette(accentColor: color))
    }
}
