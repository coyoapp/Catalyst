import SwiftUI

public struct DSTypography {
    public let title: Font
    public let body: Font
    public let label: Font

    public static var `default`: DSTypography {
        DSTypography(
            title: .system(size: DSSizes.primaryTitle, weight: .semibold),
            body: .system(size: DSSizes.primaryBody, weight: .regular),
            label: .system(size: DSSizes.primaryLabel, weight: .medium)
        )
    }
}

public extension DSTypography {
    static var secondary: DSTypography {
        DSTypography(
            title: .system(size: DSSizes.secondaryTitle, weight: .heavy),
            body: .system(size: DSSizes.secondaryBody, weight: .black),
            label: .system(size: DSSizes.secondaryLabel, weight: .semibold)
        )
    }
    
    static var dark: DSTypography {
        DSTypography(
            title: .system(size: DSSizes.darkTitle, weight: .heavy),
            body: .system(size: DSSizes.darkBody, weight: .black),
            label: .system(size: DSSizes.darkLabel, weight: .semibold)
        )
    }
}
