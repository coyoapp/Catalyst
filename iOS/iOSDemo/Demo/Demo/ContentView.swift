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
        VStack {
            VStack {
                Text("Some testing with buttons")
                    .font(DSTypography.h2)
                HStack {
                    EngageButton(
                        .iconText(icon: Image("icon-checkmark", bundle: .designSystem), text: "Button", placement: .trailing),
                        buttonSize: .medium,
                        styleConfig:  DSTheme.Components.Buttons.Primary.filledConfig
                    ) {
                        print("Button tapped")
                    }
                    EngageButton(
                        .iconText(icon: Image("icon-checkmark", bundle: .designSystem), text: "Button", placement: .trailing),
                        buttonSize: .small,
                        styleConfig: DSTheme.Components.Buttons.Primary.filledConfig
                    ) {
                        print("Button tapped")
                    }
                    EngageButton(
                        .iconText(icon: Image("icon-checkmark", bundle: .designSystem), text: "Disabled", placement: .trailing),
                        buttonSize: .extraSmall,
                        styleConfig: DSTheme.Components.Buttons.Primary.filledConfig
                    ) {
                        print("Button tapped")
                    }
                    .disabled(true)
                }
                
                HStack {
                    EngageButton(
                        .iconText(icon: Image("icon-checkmark", bundle: .designSystem), text: "Button", placement: .trailing),
                        buttonSize: .medium,
                        styleConfig: DSTheme.Components.Buttons.Primary.filledConfig
                    ) {
                        print("Button tapped")
                    }
                    
                    EngageButton(
                        .iconText(icon: Image("icon-checkmark", bundle: .designSystem), text: "Button", placement: .trailing),
                        buttonSize: .small,
                        styleConfig: DSTheme.Components.Buttons.Primary.borderConfig
                    ) {
                        print("Button tapped")
                    }
                    
                    EngageButton(
                        .iconText(icon: Image("icon-checkmark", bundle: .designSystem), text: "Button", placement: .trailing),
                        buttonSize: .extraSmall,
                        styleConfig: DSTheme.Components.Buttons.Primary.borderConfig
                    ) {
                        print("Button tapped")
                    }
                }
                
                EngageButton(
                    .iconText(icon: Image("icon-checkmark", bundle: .designSystem), text: "Button", placement: .leading),
                    buttonSize: .small,
                    styleConfig: DSTheme.Components.Buttons.Primary.ghostConfig
                ) {
                    print("Button tapped")
                }
                .frame(width: 150)
            }
            
            HStack {
                EngageButton(
                    .icon(Image("icon-checkmark", bundle: .designSystem)),
                    buttonSize: .extraSmall,
                    styleConfig: DSTheme.Components.Buttons.Primary.filledConfig
                ) {
                    print("Button tapped")
                }
                .frame(width: 50)
                
                EngageButton(
                    .icon(Image("icon-checkmark", bundle: .designSystem)),
                    styleConfig: DSTheme.Components.Buttons.Accent.filledConfig(accentColor: .blue)
                ) {
                    print("Button tapped")
                }
                .frame(width: 50)
                
                EngageButton(
                    .icon(Image("icon-checkmark", bundle: .designSystem)),
                    styleConfig: DSTheme.Components.Buttons.Accent.filledConfig(accentColor: Color(red: 0.00, green: 0.51, blue: 0.58))
                ) {
                    print("Button tapped")
                }
                .frame(width: 50)
            }
            
//            EngageButton(
//                .iconText(icon: Image("reaction-recognize", bundle: .designSystem), text: "Recognition", placement: .leading),
//                styleConfig: DSTheme.ThemeKudosButton.primaryColorConfig,
//                padding: DSTheme.ThemeKudosButton.padding
//            ) {
//                print("Button tapped")
//            }
//            .frame(width: 109, height: 109)
        }
        
        ScrollView {
            
            EngageKudosButton(
                .iconText(icon: Image("reaction-appreciate", bundle: .designSystem), text: "Appreciation", placement: .top),
            ) {
                print("Button tapped")
            }
            .frame(width: 150, height: 150)
            
            HStack {
                EngageButton(
                    .iconText(icon: Image("icon-checkmark", bundle: .designSystem), text: "Button", placement: .leading),
                    styleConfig: DSTheme.Components.Buttons.Primary.filledConfig
                ) {
                    print("Button tapped")
                }
                .frame(width: DSSizes.size5xl, height: DSSizes.size5xl)
                
                EngageButton(
                    .icon(Image("icon-checkmark", bundle: .designSystem)),
                    styleConfig: DSTheme.Components.Buttons.Primary.filledConfig
                ) {
                    print("Button tapped")
                }
            }
            
            
            EngageThemeProvider(theme: .dark) {
//                VStack(spacing: theme.spacing.spacingXs) {
//                    Text("Design System Demo")
//                        .font(theme.typography.title)
//                        .foregroundColor(theme.colors.colorThemeDangerText)
//                    
//                    ThemedTextView()
//                    
//                    PrimaryButton("Click Me") {
//                        print("Button tapped")
//                    }
//                    
//                    PrimaryButtonWithTheme("Click Me") {
//                        print("Button tapped")
//                    }
//                }
//                .padding()
                
//                Image("Union", bundle: .designSystem)
//                    .resizable()
//                    .frame(width: 50, height: 50)
//                    .foregroundStyle(Color.black)
//                
//                Image("Avatar-2", bundle: .designSystem)
//                    .resizable()
//                    .frame(width: 50, height: 50)
//                
//                Image("reaction-appreciate", bundle: .designSystem)
//                    .resizable()
//                    .frame(width: 25, height: 25)
//                    .background(DSColors.colorThemeDangerBg)
                
                VStack {
                    EngageButton(
                        .iconText(icon: Image("icon-checkmark", bundle: .designSystem), text: "Button", placement: .trailing),
                        styleConfig: DSTheme.Components.Buttons.Primary.ghostConfig,
                        padding: EdgeInsets(top: DSSpacing.spacingLg, leading: DSSpacing.spacingXl, bottom: DSSpacing.spacingLg, trailing: DSSpacing.spacingXl)
                    ) {
                        print("Button tapped")
                    }
                    
                    EngageButton(
                        .icon(Image("icon-checkmark", bundle: .designSystem)),
                        styleConfig: DSTheme.Components.Buttons.Primary.filledConfig
                    ) {
                        print("Button tapped")
                    }
                }
                
                
                EngageButton(
                    .iconText(icon: Image("icon-checkmark", bundle: .designSystem), text: "Button Border", placement: .trailing),
                    styleConfig: DSTheme.Components.Buttons.Primary.filledConfig
                ) {
                    print("Button tapped")
                }
                
                
                EngageButton(
                    .iconText(icon: Image("icon-checkmark", bundle: .designSystem), text: "Button Ghost", placement: .trailing),
                    styleConfig: DSTheme.Components.Buttons.Primary.ghostConfig
                ) {
                    print("Button tapped")
                }
            }
            
            Image("reaction-appreciate", bundle: .designSystem)
                .resizable()
                .renderingMode(.template)
                .foregroundColor(Color.blue)
                .frame(width: 50, height: 50)
                .padding()
            
            Text("TRY Generated Colors")
                .background(DSColors.colorThemeInfoBg)
                .foregroundColor(DSColors.colorThemeSecondaryTextActive)
            Text("TRY COLORS")
                .background(DSColors.colorThemeDangerBg)
                .foregroundColor(DSColors.colorThemeDangerText)
        }
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
