//
//  ContentView.swift
//  Demo
//
//  Created by Efe Durmaz on 18.09.25.
//

import SwiftUI
import SwiftData
import Catalyst

// NOTE: Theme settings on Environment values wont be directly applied to view. It will be applied to the child thats why you'll need to wrap it up to a Themed View, as you can see .dark or .default wont have any effect on the Text() view but will have on ThemedTextView.

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    
    var body: some View {
        VStack {
            VStack {
                Text("Catalyst Demo")
                    .font(CatTypography.h1)
                    .foregroundStyle(CatColors.Theme.Danger.text)
                HStack {
                    VStack(alignment: .leading) {
                        Text("Filled button set with catButtonConfig")
                            .font(CatTypography.body1)
                            .padding(5)
                        VStack {
                            CatButton(
                                .iconText(icon: Image("icon-checkmark", bundle: .catalyst),
                                          text: "Button",
                                          placement: .leading),
                                buttonSize: .medium,
                            ) {
                                print("Button tapped")
                            }
                            .catButtonConfig(variant: .filled, color: .primary)
                            
                            CatButton(
                                .iconText(icon: Image("icon-checkmark", bundle: .catalyst),
                                          text: "Primary",
                                          placement: .trailing),
                                buttonSize: .medium,
                            ) {
                                print("Button tapped")
                            }
                            .catButtonConfig(variant: .filled, color: .primary)
                            
                            CatButton(
                                .iconText(icon: Image("icon-checkmark", bundle: .catalyst),
                                          text: "Secondary",
                                          placement: .trailing),
                                buttonSize: .medium,
                            ) {
                                print("Button tapped")
                            }
                            .catButtonConfig(variant: .filled, color: .secondary)
                            
                            CatButton(
                                .iconText(icon: Image("icon-checkmark", bundle: .catalyst), text: "Danger", placement: .trailing),
                                buttonSize: .medium,
                            ) {
                                print("Button tapped")
                            }
                            .catButtonConfig(variant: .filled, color: .danger)
                            
                            CatButton(
                                .iconText(icon: Image("icon-checkmark", bundle: .catalyst), text: "Success", placement: .trailing),
                                buttonSize: .medium
                            ) {
                                print("Button tapped")
                            }
                            .catButtonConfig(variant: .filled, color: .success)
                            
                            CatButton(
                                .iconText(icon: Image("icon-checkmark", bundle: .catalyst), text: "Warning", placement: .trailing),
                                buttonSize: .medium,
                            ) {
                                print("Button tapped")
                            }
                            .catButtonConfig(variant: .filled, color: .warning)
                            
                            CatButton(
                                .iconText(icon: Image("icon-checkmark", bundle: .catalyst), text: "Info", placement: .trailing),
                                buttonSize: .medium,
                            ) {
                                print("Button tapped")
                            }
                            .catButtonConfig(variant: .filled, color: .info)
                            
                            CatButton(
                                .iconText(icon: Image("icon-checkmark", bundle: .catalyst), text: "PrimaryInverted", placement: .trailing),
                                buttonSize: .medium,
                            ) {
                                print("Button tapped")
                            }
                            .catButtonConfig(variant: .outlined, color: .primaryInverted)
                            
                            CatButton(
                                .iconText(icon: Image("icon-checkmark", bundle: .catalyst), text: "SecondaryInverted", placement: .trailing),
                                buttonSize: .medium,
                            ) {
                                print("Button tapped")
                            }
                            .catButtonConfig(variant: .filled, color: .secondaryInverted)
                            
                            CatButton(
                                .iconText(icon: Image("icon-checkmark", bundle: .catalyst), text: "Accent (TODO)", placement: .trailing),
                                buttonSize: .medium,
                            ) {
                                print("Button tapped")
                            }
                            .catButtonConfig(variant: .filled, color: .accent)
                        }
                        .padding(.horizontal)
                    }

                    VStack(alignment: .leading) {
                        Text("Outlined button set with catButtonConfig")
                            .font(CatTypography.body1)
                            .padding(5)
                        VStack {
                            CatButton(
                                .iconText(icon: Image("icon-checkmark", bundle: .catalyst),
                                          text: "Button",
                                          placement: .leading),
                                buttonSize: .medium,
                            ) {
                                print("Button tapped")
                            }
                            .catButtonConfig(variant: .outlined, color: .primary)
                            
                            CatButton(
                                .iconText(icon: Image("icon-checkmark", bundle: .catalyst),
                                          text: "Primary",
                                          placement: .trailing),
                                buttonSize: .medium,
                            ) {
                                print("Button tapped")
                            }
                            .catButtonConfig(variant: .outlined, color: .primary)
                            
                            CatButton(
                                .iconText(icon: Image("icon-checkmark", bundle: .catalyst),
                                          text: "Secondary",
                                          placement: .trailing),
                                buttonSize: .medium,
                            ) {
                                print("Button tapped")
                            }
                            .catButtonConfig(variant: .outlined, color: .secondary)
                            
                            CatButton(
                                .iconText(icon: Image("icon-checkmark", bundle: .catalyst), text: "Danger", placement: .trailing),
                                buttonSize: .medium,
                            ) {
                                print("Button tapped")
                            }
                            .catButtonConfig(variant: .outlined, color: .danger)
                            
                            CatButton(
                                .iconText(icon: Image("icon-checkmark", bundle: .catalyst), text: "Success", placement: .trailing),
                                buttonSize: .medium
                            ) {
                                print("Button tapped")
                            }
                            .catButtonConfig(variant: .outlined, color: .success)
                            
                            CatButton(
                                .iconText(icon: Image("icon-checkmark", bundle: .catalyst), text: "Warning", placement: .trailing),
                                buttonSize: .medium,
                            ) {
                                print("Button tapped")
                            }
                            .catButtonConfig(variant: .outlined, color: .warning)
                            
                            CatButton(
                                .iconText(icon: Image("icon-checkmark", bundle: .catalyst), text: "Info", placement: .trailing),
                                buttonSize: .medium,
                            ) {
                                print("Button tapped")
                            }
                            .catButtonConfig(variant: .outlined, color: .info)
                            
                            CatButton(
                                .iconText(icon: Image("icon-checkmark", bundle: .catalyst), text: "PrimaryInverted", placement: .trailing),
                                buttonSize: .medium,
                            ) {
                                print("Button tapped")
                            }
                            .catButtonConfig(variant: .outlined, color: .primaryInverted)
                            
                            CatButton(
                                .iconText(icon: Image("icon-checkmark", bundle: .catalyst), text: "SecondaryInverted", placement: .trailing),
                                buttonSize: .medium,
                            ) {
                                print("Button tapped")
                            }
                            .catButtonConfig(variant: .outlined, color: .secondaryInverted)
                            
                            CatButton(
                                .iconText(icon: Image("icon-checkmark", bundle: .catalyst), text: "Accent (TODO)", placement: .trailing),
                                buttonSize: .medium,
                            ) {
                                print("Button tapped")
                            }
                            .catButtonConfig(variant: .outlined, color: .accent)
                        }
                        .padding(.horizontal)
                    }
                }
            }
            
            Text("Buttons with accent color with old Styling")
                .font(CatTypography.caption)
            CatButton(
                .iconText(icon: Image("icon-checkmark", bundle: .catalyst), text: "Button", placement: .trailing),
                buttonSize: .extraSmall,
                styleConfig: CatTheme.Components.Buttons.Accent.filledConfig(accentColor: .red)
            ) {
                print("Button tapped")
            }
            .padding(.horizontal)
        }
        
        VStack {
            HStack {
                Image("Union", bundle: .catalyst)
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 40, height: 40)
                    .font(CatTypography.h2)
                    .foregroundColor(CatColors.Theme.Danger.text)
                
                Image("reaction-appreciate", bundle: .catalyst)
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(Color.blue)
                    .frame(width: 50, height: 50)
            }
        }
        .padding()
        
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
