import SwiftUI

public struct PrimaryButtonWithTheme: View {
    private let title: String
    private let action: () -> Void

    @Environment(\.engageTheme) private var theme
    
    public init(_ title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            Text("Theme: \(title)")
                .font(theme.typography.title)
                .foregroundColor(theme.colors.colorThemeDangerBg)
                .padding(theme.spacing.spacingMd)
                .frame(maxWidth: .infinity)
        }
        
        .background(theme.colors.colorThemeDangerBgActive)
        .cornerRadius(12)
    }
}

public struct PrimaryButton: View {
    private let title: String
    private let action: () -> Void

    @Environment(\.engageTheme) private var theme
    
    public init(_ title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            Text(title)
                .font(DSTypographyTest.default.title)
                .foregroundColor(DSColors.colorThemeInfoText)
                .padding(.vertical, DSSpacing.spacingMd)
                .padding(.horizontal, DSSpacing.spacingLg)
                .frame(maxWidth: .infinity)
        }
        
        .background(DSColors.colorThemeInfoBg)
        .cornerRadius(12)
    }
}
