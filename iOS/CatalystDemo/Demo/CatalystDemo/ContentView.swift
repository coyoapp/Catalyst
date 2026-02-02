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
                    .foregroundStyle(CatColors.colorThemeDangerText)
                VStack(alignment: .leading) {
                    Text("Filled Config with Fonts: h1, h2 and h3")
                        .font(CatTypography.body1)
                        .padding(.top, 5)
                    HStack {
                        CatButton(
                            .iconText(icon: Image("icon-checkmark", bundle: .catalyst),
                                      text: "Button",
                                      placement: .trailing),
                            buttonSize: .medium,
                            styleConfig: CatTheme.Components.Buttons.Primary.filledConfig,
                            styleFont: CatTypography.h1
                        ) {
                            print("Button tapped")
                        }
                        CatButton(
                            .iconText(icon: Image("icon-checkmark", bundle: .catalyst), text: "Button", placement: .trailing),
                            buttonSize: .small,
                            styleConfig: CatTheme.Components.Buttons.Primary.filledConfig,
                            styleFont: CatTypography.h2
                        ) {
                            print("Button tapped")
                        }
                        CatButton(
                            .iconText(icon: Image("icon-checkmark", bundle: .catalyst), text: "Disabled", placement: .trailing),
                            buttonSize: .extraSmall,
                            styleConfig: CatTheme.Components.Buttons.Primary.filledConfig,
                            styleFont: CatTypography.h3
                        ) {
                            print("Button tapped")
                        }
                        .disabled(true)
                    }
                }
                
                VStack(alignment: .leading) {
                    Text("Border Config with Fonts: h4, body1, body2")
                        .font(CatTypography.body1)
                        .padding(.top, 5)
                    HStack {
                        CatButton(
                            .iconText(icon: Image("icon-checkmark", bundle: .catalyst), text: "Button", placement: .trailing),
                            buttonSize: .medium,
                            styleConfig: CatTheme.Components.Buttons.Primary.borderConfig,
                            styleFont: CatTypography.h4
                        ) {
                            print("Button tapped")
                        }
                        
                        CatButton(
                            .iconText(icon: Image("icon-checkmark", bundle: .catalyst), text: "Button", placement: .trailing),
                            buttonSize: .small,
                            styleConfig: CatTheme.Components.Buttons.Primary.borderConfig,
                            styleFont: CatTypography.body1
                        ) {
                            print("Button tapped")
                        }
                        
                        CatButton(
                            .iconText(icon: Image("icon-checkmark", bundle: .catalyst), text: "Disabled", placement: .trailing),
                            buttonSize: .extraSmall,
                            styleConfig: CatTheme.Components.Buttons.Primary.borderConfig,
                            styleFont: CatTypography.body2
                        ) {
                            print("Button tapped")
                        }
                        .disabled(true)
                    }
                }
                
                VStack(alignment: .leading) {
                    Text("Link Config with Fonts: s1, s2 & default (s1)")
                        .font(CatTypography.body1)
                        .padding(.top, 5)
                    HStack {
                        CatButton(
                            .iconText(icon: Image("icon-checkmark", bundle: .catalyst), text: "Button", placement: .leading),
                            buttonSize: .small,
                            styleConfig: CatTheme.Components.Buttons.Primary.linkConfig,
                            styleFont: CatTypography.s1
                        ) {
                            print("Button tapped")
                        }
                        .frame(width: 150)
                        
                        CatButton(
                            .iconText(icon: Image("icon-checkmark", bundle: .catalyst), text: "Button", placement: .leading),
                            buttonSize: .extraSmall,
                            styleConfig: CatTheme.Components.Buttons.Primary.linkConfig,
                            styleFont: CatTypography.s2
                        ) {
                            print("Button tapped")
                        }
                        .frame(width: 150)
                        
                        CatButton(
                            .iconText(icon: Image("icon-checkmark", bundle: .catalyst), text: "Disabled", placement: .leading),
                            buttonSize: .extraSmall,
                            styleConfig: CatTheme.Components.Buttons.Primary.linkConfig
                        ) {
                            print("Button tapped")
                        }
                        .frame(width: 150)
                        .disabled(true)
                        
                    }
                    
                }
            }
            
            VStack(alignment: .leading) {
                Text("Ghost Config with Fonts: button, caption & overline")
                    .font(CatTypography.body1)
                    .padding(.top, 5)
                HStack {
                    CatButton(
                        .iconText(icon: Image("icon-checkmark", bundle: .catalyst), text: "Button", placement: .leading),
                        buttonSize: .small,
                        styleConfig: CatTheme.Components.Buttons.Primary.ghostConfig,
                        styleFont: CatTypography.button
                    ) {
                        print("Button tapped")
                    }
                    .frame(width: 150)
                    
                    CatButton(
                        .iconText(icon: Image("icon-checkmark", bundle: .catalyst), text: "Button", placement: .leading),
                        buttonSize: .extraSmall,
                        styleConfig: CatTheme.Components.Buttons.Primary.ghostConfig,
                        styleFont: CatTypography.caption
                    ) {
                        print("Button tapped")
                    }
                    .frame(width: 150)
                    
                    CatButton(
                        .iconText(icon: Image("icon-checkmark", bundle: .catalyst), text: "Disabled", placement: .leading),
                        buttonSize: .extraSmall,
                        styleConfig: CatTheme.Components.Buttons.Primary.ghostConfig,
                        styleFont: CatTypography.overline
                    ) {
                        print("Button tapped")
                    }
                    .frame(width: 150)
                    .disabled(true)
                }
            }
            
            Text("Dafult setup")
                .font(CatTypography.body1)
                .padding(.top, 5)
            CatButton(
                .iconText(icon: Image("icon-checkmark", bundle: .catalyst), text: "Default Button", placement: .leading),
                styleConfig: CatTheme.Components.Buttons.Primary.filledConfig,
            ) {
                print("Button tapped")
            }
            .frame(width: 175)
            
            Text("Buttons with accent color")
                .font(CatTypography.body1)
                .padding(.top, 5)
            HStack(spacing: 50) {
                CatButton(
                    .icon(Image("icon-checkmark", bundle: .catalyst)),
                    buttonSize: .extraSmall,
                    styleConfig: CatTheme.Components.Buttons.Accent.filledConfig(accentColor: .red)
                ) {
                    print("Button tapped")
                }
                .frame(width: 50)
                
                CatButton(
                    .icon(Image("icon-checkmark", bundle: .catalyst)),
                    buttonSize: .small,
                    styleConfig: CatTheme.Components.Buttons.Accent.borderConfig(accentColor: .red)
                ) {
                    print("Button tapped")
                }
                .frame(width: 50)
                
                CatButton(
                    .iconText(icon: Image("icon-checkmark", bundle: .catalyst), text: "Link", placement: .trailing),
                    buttonSize: .medium,
                    styleConfig: CatTheme.Components.Buttons.Accent.linkConfig(accentColor: .red)
                ) {
                    print("Button tapped")
                }
                .frame(width: 100)
            }
        }
        
        ScrollView {
            Text("Scroll View")
                .font(CatTypography.body1)
            
            EngageKudosButton(
                .iconText(icon: Image("reaction-appreciate", bundle: .catalyst), text: "Appreciation", placement: .top),
            ) {
                print("Button tapped")
            }
            .frame(width: 150)
            
            HStack {
                CatButton(
                    .iconText(
                        icon: Image("icon-checkmark", bundle: .catalyst),
                        text: "Button",
                        placement: .leading
                    ),
                    styleConfig: CatTheme.Components.Buttons.Primary.filledConfig
                ) {
                    print("Button tapped")
                }
            }
            
            VStack {
                HStack {
                    Image("Union", bundle: .catalyst)
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 40, height: 40)
                    
                    Text("ThemeProvider")
                }
                .font(CatTypography.h2)
                .foregroundColor(CatColors.colorThemeDangerText)
            }
            .padding()
            
            VStack {
                CatButton(
                    .iconText(icon: Image("icon-checkmark", bundle: .catalyst), text: "Button", placement: .trailing),
                    styleConfig: CatTheme.Components.Buttons.Primary.ghostConfig,
                    padding: EdgeInsets(top: CatSpacing.spacingLg, leading: CatSpacing.spacingXl, bottom: CatSpacing.spacingLg, trailing: CatSpacing.spacingXl)
                ) {
                    print("Button tapped")
                }
                
                CatButton(
                    .icon(Image("icon-checkmark", bundle: .catalyst)),
                    styleConfig: CatTheme.Components.Buttons.Primary.filledConfig
                ) {
                    print("Button tapped")
                }
            }
            
            CatButton(
                .iconText(icon: Image("icon-checkmark", bundle: .catalyst), text: "Button Border", placement: .trailing),
                styleConfig: CatTheme.Components.Buttons.Primary.borderConfig
            ) {
                print("Button tapped")
            }
            
            CatButton(
                .iconText(icon: Image("icon-checkmark", bundle: .catalyst), text: "Button Ghost", placement: .trailing),
                styleConfig: CatTheme.Components.Buttons.Primary.ghostConfig
            ) {
                print("Button tapped")
            }
        }
        
        Image("reaction-appreciate", bundle: .catalyst)
            .resizable()
            .renderingMode(.template)
            .foregroundColor(Color.blue)
            .frame(width: 50, height: 50)
            .padding()
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
