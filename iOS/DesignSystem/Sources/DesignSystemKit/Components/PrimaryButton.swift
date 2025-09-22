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
                .foregroundColor(theme.colors.textLight)
                .padding(theme.spacing.md.rawValue)
                .frame(maxWidth: .infinity)
        }
        
        .background(theme.colors.primary)
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
                .font(DSTypography.default.title)
                .foregroundColor(DSColors.textLight)
                .padding(.vertical, DSSpacing.md.rawValue)
                .padding(.horizontal, DSSpacing.lg.rawValue)
                .frame(maxWidth: .infinity)
        }
        
        .background(DSColors.primary)
        .cornerRadius(12)
    }
}
