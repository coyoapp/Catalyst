import SwiftUI

public struct DSTypographyTest {
    public let title: Font
    public let body: Font
    public let label: Font

    public static var `default`: DSTypographyTest {
        DSTypographyTest(
            title: .system(size: DSSizesTest.primaryTitle, weight: .semibold),
            body: .system(size: DSSizesTest.primaryBody, weight: .regular),
            label: .system(size: DSSizesTest.primaryLabel, weight: .medium)
        )
    }
}

public extension DSTypographyTest {
    static var secondary: DSTypographyTest {
        DSTypographyTest(
            title: .system(size: DSSizesTest.secondaryTitle, weight: .heavy),
            body: .system(size: DSSizesTest.secondaryBody, weight: .black),
            label: .system(size: DSSizesTest.secondaryLabel, weight: .semibold)
        )
    }
    
    static var dark: DSTypographyTest {
        DSTypographyTest(
            title: .system(size: DSSizesTest.darkTitle, weight: .heavy),
            body: .system(size: DSSizesTest.darkBody, weight: .black),
            label: .system(size: DSSizesTest.darkLabel, weight: .semibold)
        )
    }
}
