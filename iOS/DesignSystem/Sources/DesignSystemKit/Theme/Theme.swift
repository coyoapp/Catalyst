import SwiftUI

public struct EngageTheme {
    public let colors: DSColorsProtocol.Type
    public let typography: DSTypography
    public let spacing: DSSpacing.Type
    public let sizes: DSSizes.Type

    public static var `default`: EngageTheme {
        EngageTheme(
            colors: DSColorsLight.self,
            typography: .default,
            spacing: DSSpacing.self,
            sizes: DSSizes.self
        )
    }
}

public struct EngageThemeKey: EnvironmentKey {
    public static var defaultValue: EngageTheme {
        .default
    }
}

public extension EnvironmentValues {
    var engageTheme: EngageTheme {
        get { self[EngageThemeKey.self] }
        set { self[EngageThemeKey.self] = newValue }
    }
}

public struct EngageThemeProvider<Content: View>: View {
    private let theme: EngageTheme
    private let content: Content

    public init(theme: EngageTheme = .default, @ViewBuilder content: () -> Content) {
        self.theme = theme
        self.content = content()
    }

    public var body: some View {
        content.environment(\.engageTheme, theme)
    }
}

// MARK: Theme Extensions:
public extension EngageTheme {
    static var dark: EngageTheme {
        EngageTheme(
            colors: DSColorsDark.self,
            typography: .dark,
            spacing: DSSpacing.self,
            sizes: DSSizes.self
        )
    }
}
