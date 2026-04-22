//
// CatTypography.swift
//
// Do not edit directly, this file is generated from design tokens
//

import SwiftUI
import UIKit

public enum CatTypography {
    public static let h1 = Font.custom("\(CatTheme.fontFamily)-Bold", size: 32.00)
    public static let h2 = Font.custom("\(CatTheme.fontFamily)-Semibold", size: 28.00)
    public static let h3 = Font.custom("\(CatTheme.fontFamily)-Semibold", size: 24.00)
    public static let h4 = Font.custom("\(CatTheme.fontFamily)-Semibold", size: 20.00)
    public static let body1 = Font.custom("\(CatTheme.fontFamily)-Regular", size: 16.00)
    public static let body2 = Font.custom("\(CatTheme.fontFamily)-Regular", size: 14.00)
    public static let s1 = Font.custom("\(CatTheme.fontFamily)-Semibold", size: 16.00)
    public static let s2 = Font.custom("\(CatTheme.fontFamily)-Semibold", size: 14.00)
    public static let button1 = Font.custom("\(CatTheme.fontFamily)-Semibold", size: 16.00)
    public static let button2 = Font.custom("\(CatTheme.fontFamily)-Regular", size: 16.00)
    public static let caption = Font.custom("\(CatTheme.fontFamily)-Regular", size: 12.00)
    public static let overline = Font.custom("\(CatTheme.fontFamily)-Regular", size: 10.00)
}

public enum CatTypographyUIFont {
    private static func font(_ name: String, size: CGFloat) -> UIFont {
        UIFont(name: name, size: size) ?? .systemFont(ofSize: size)
    }

    public static let h1 = font("\(CatTheme.fontFamily)-Bold", size: 32)
    public static let h2 = font("\(CatTheme.fontFamily)-Semibold", size: 28)
    public static let h3 = font("\(CatTheme.fontFamily)-Semibold", size: 24)
    public static let h4 = font("\(CatTheme.fontFamily)-Semibold", size: 20)
    public static let body1 = font("\(CatTheme.fontFamily)-Regular", size: 16)
    public static let body2 = font("\(CatTheme.fontFamily)-Regular", size: 14)
    public static let s1 = font("\(CatTheme.fontFamily)-Semibold", size: 16)
    public static let s2 = font("\(CatTheme.fontFamily)-Semibold", size: 14)
    public static let button1 = font("\(CatTheme.fontFamily)-Semibold", size: 16)
    public static let button2 = font("\(CatTheme.fontFamily)-Regular", size: 16)
    public static let caption = font("\(CatTheme.fontFamily)-Regular", size: 12)
    public static let overline = font("\(CatTheme.fontFamily)-Regular", size: 10)
}
