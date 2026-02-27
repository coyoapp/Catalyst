//
//  CatThemeEnvironment.swift
//  Catalyst
//
//  Created by Efe Durmaz on 27.02.26.
//

import SwiftUI

private struct CatThemeEnvironmentKey: EnvironmentKey {
    static let defaultValue: CatTheme.ThemeType = .primaryHaiilo
}

public extension EnvironmentValues {
    var catalystTheme: CatTheme.ThemeType {
        get { self[CatThemeEnvironmentKey.self] }
        set { self[CatThemeEnvironmentKey.self] = newValue }
    }
}

public extension View {
    func catalystTheme(_ theme: CatTheme.ThemeType) -> some View {
        environment(\.catalystTheme, theme)
    }
}
