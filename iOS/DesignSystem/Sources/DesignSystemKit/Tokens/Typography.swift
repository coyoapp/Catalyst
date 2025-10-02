import SwiftUI

public struct DSTypographyTest {
    public let title: Font
    public let body: Font
    public let label: Font

    public static var `default`: DSTypographyTest {
        DSTypographyTest(
            title: .system(size: DSSizes.sizeLg, weight: .semibold),
            body: .system(size: DSSizes.sizeMd, weight: .regular),
            label: .system(size: DSSizes.sizeSm, weight: .medium)
        )
    }
}

public extension DSTypographyTest {
    static var secondary: DSTypographyTest {
        DSTypographyTest(
            title: .system(size: DSSizes.sizeLg, weight: .heavy),
            body: .system(size: DSSizes.sizeMd, weight: .black),
            label: .system(size: DSSizes.sizeSm, weight: .semibold)
        )
    }
    
    static var dark: DSTypographyTest {
        DSTypographyTest(
            title: .system(size: DSSizes.sizeLg, weight: .heavy),
            body: .system(size: DSSizes.sizeMd, weight: .black),
            label: .system(size: DSSizes.sizeSm, weight: .semibold)
        )
    }
}
