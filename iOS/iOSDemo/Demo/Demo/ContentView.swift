//
//  ContentView.swift
//  Demo
//
//  Created by Efe Durmaz on 18.09.25.
//

import SwiftUI
import SwiftData
import DesignSystemKit

// NOTE: Theme settings on Environment values wont be directly applied to view. It will be applied to the child thats why you'll need to wrap it up to a Themed View, as you can see .dark or .default wont have any effect on the Text() view but will have on ThemedTextView.

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.engageTheme) private var theme
    @Query private var items: [Item]

    var body: some View {
        
        EngageThemeProvider(theme: .dark) {
            VStack(spacing: theme.spacing.spacingXs) {
                Text("Design System Demo")
                    .font(theme.typography.title)
                    .foregroundColor(theme.colors.colorThemeDangerText)
                
                ThemedTextView()
                
                PrimaryButton("Click Me") {
                    print("Button tapped")
                }
                
                PrimaryButtonWithTheme("Click Me") {
                    print("Button tapped")
                }
            }
            .padding()
            
            Image("Union", bundle: .designSystem)
                .resizable()
                .frame(width: 50, height: 50)
                .foregroundStyle(Color.black)
            
            Image("reaction-appreciate", bundle: .designSystem)
                .resizable()
                .frame(width: 25, height: 25)
                .background(DSColors.colorThemeDangerBg)
        }
        
        Image("reaction-appreciate", bundle: .designSystem)
            .resizable()
            .frame(width: 50, height: 50)
            .foregroundStyle(Color.black)
            .padding()
        
        Text("TRY Generated Colors")
            .background(DSColors.colorThemeInfoBg)
            .foregroundColor(DSColors.colorThemeSecondaryTextActive)
        Text("TRY COLORS")
            .background(DSColors.colorThemeDangerBg)
            .foregroundColor(DSColors.colorThemeDangerText)
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

struct ThemedTextView: View {
    @Environment(\.engageTheme) private var theme
    
    var body: some View {
        VStack(spacing: theme.spacing.spacingXs) {
            Text("Design System Demo")
                .font(theme.typography.title)
                .foregroundColor(theme.colors.colorThemePrimaryText)
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
