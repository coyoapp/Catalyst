import SwiftUI

public struct DSTypography {
    public let title: Font
    public let body: Font
    public let label: Font

    public static var `default`: DSTypography {
        DSTypography(
            title: .system(size: DSSizesTest.primaryTitle, weight: .semibold),
            body: .system(size: DSSizesTest.primaryBody, weight: .regular),
            label: .system(size: DSSizesTest.primaryLabel, weight: .medium)
        )
    }
}

public extension DSTypography {
    static var secondary: DSTypography {
        DSTypography(
            title: .system(size: DSSizesTest.secondaryTitle, weight: .heavy),
            body: .system(size: DSSizesTest.secondaryBody, weight: .black),
            label: .system(size: DSSizesTest.secondaryLabel, weight: .semibold)
        )
    }
    
    static var dark: DSTypography {
        DSTypography(
            title: .system(size: DSSizesTest.darkTitle, weight: .heavy),
            body: .system(size: DSSizesTest.darkBody, weight: .black),
            label: .system(size: DSSizesTest.darkLabel, weight: .semibold)
        )
    }
}
