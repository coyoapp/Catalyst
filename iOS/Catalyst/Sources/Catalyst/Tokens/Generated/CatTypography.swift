//
// CatTypography.swift
//
// Do not edit directly, this file is generated from design tokens
//

import SwiftUI
import UIKit

public enum CatTypography {
    public static let h1 = Font.custom("Lato-Bold", size: 32.00)
    public static let h2 = Font.custom("Lato-Semibold", size: 28.00)
    public static let h3 = Font.custom("Lato-Semibold", size: 24.00)
    public static let h4 = Font.custom("Lato-Semibold", size: 20.00)
    public static let body1 = Font.custom("Lato-Regular", size: 16.00)
    public static let body2 = Font.custom("Lato-Regular", size: 14.00)
    public static let s1 = Font.custom("Lato-Semibold", size: 16.00)
    public static let s2 = Font.custom("Lato-Semibold", size: 14.00)
    public static let button1 = Font.custom("Lato-Semibold", size: 16.00)
    public static let button2 = Font.custom("Lato-Regular", size: 16.00)
    public static let caption = Font.custom("Lato-Regular", size: 12.00)
    public static let overline = Font.custom("Lato-Regular", size: 10.00)
}

public enum CatTypographyUIFont {
    private static func font(_ name: String, size: CGFloat) -> UIFont {
        UIFont(name: name, size: size) ?? .systemFont(ofSize: size)
    }

    public static let h1 = font("Lato-Bold", size: 32)
    public static let h2 = font("Lato-Semibold", size: 28)
    public static let h3 = font("Lato-Semibold", size: 24)
    public static let h4 = font("Lato-Semibold", size: 20)
    public static let body1 = font("Lato-Regular", size: 16)
    public static let body2 = font("Lato-Regular", size: 14)
    public static let s1 = font("Lato-Semibold", size: 16)
    public static let s2 = font("Lato-Semibold", size: 14)
    public static let button1 = font("Lato-Semibold", size: 16)
    public static let button2 = font("Lato-Regular", size: 16)
    public static let caption = font("Lato-Regular", size: 12)
    public static let overline = font("Lato-Regular", size: 10)
}
