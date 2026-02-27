//
//  UIApplicationDelegate+Catalyst.swift
//  Catalyst
//
//  Convenience bootstrap for host app startup.
//

import UIKit

public extension UIApplicationDelegate {
    /// Call from `application(_:didFinishLaunchingWithOptions:)` to bootstrap Catalyst.
    /// - Parameter theme: The theme to activate. Defaults to `.primaryHaiilo`.
    func configureCatalyst(theme: CatTheme.ThemeType = .primaryHaiilo) {
        CatTheme.configure(theme: theme)
    }
}
