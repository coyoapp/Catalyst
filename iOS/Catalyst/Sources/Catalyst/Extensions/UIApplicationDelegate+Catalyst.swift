//
//  UIApplicationDelegate+Catalyst.swift
//  Catalyst
//
//  Convenience bootstrap for host app startup.
//

import UIKit

public extension UIApplicationDelegate {
    // Call from `application(_:didFinishLaunchingWithOptions:)` to register Catalyst resources
    func configureCatalyst() {
        CatTheme.configure()
    }
}
