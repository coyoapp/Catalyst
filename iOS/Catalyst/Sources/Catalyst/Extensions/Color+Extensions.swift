//
//  Color+Extensions.swift
//  DesignSystemKit
//
//  Created by Efe Durmaz on 04.12.25.
//

import SwiftUI

public extension Color {
    
    /// Returns a darker version of the color.
    /// - Parameter percentage: Value between 0...1 (0.2 = 20% darker)
    func darken(by percentage: CGFloat) -> Color {
        adjust(brightnessBy: -abs(percentage))
    }

    /// Returns a lighter version of the color.
    func lighten(by percentage: CGFloat) -> Color {
        adjust(brightnessBy: abs(percentage))
    }

    private func adjust(brightnessBy percentage: CGFloat) -> Color {
        let uiColor = UIColor(self)

        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0

        guard uiColor.getRed(&r, green: &g, blue: &b, alpha: &a) else {
            return self // fallback if conversion fails
        }

        return Color(
            red: max(min(r + percentage * r, 1.0), 0.0),
            green: max(min(g + percentage * g, 1.0), 0.0),
            blue: max(min(b + percentage * b, 1.0), 0.0),
            opacity: Double(a)
        )
    }
}
