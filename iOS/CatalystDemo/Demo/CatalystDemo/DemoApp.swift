//
//  DemoApp.swift
//  Demo
//
//  Created by Efe Durmaz on 18.09.25.
//

import Catalyst
import SwiftUI
import SwiftData

@main
struct DemoApp: App {
    @State private var theme: CatTheme.ThemeType = .primaryHaiilo

    init() {
        CatTheme.configure()
    }

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .catalystTheme(theme)
        }
        .modelContainer(sharedModelContainer)
    }
}
