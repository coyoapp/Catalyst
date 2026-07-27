//
//  ToastMsgDemoView.swift
//  CatalistDemo
//
//  Created by Efe Durmaz on 22.07.26.
//

import SwiftUI
import Catalyst

struct ToastMsgDemoView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Toast Msg")
                .font(CatTypography.h2)
            
            ScrollView {
                CatToastMsg(
                    "Hello World",
                    showDismissButton: false
                )
                
                CatToastMsg(
                    "Toast with Icon",
                    icon: Image("ic_check-circle-outlined-24", bundle: .catalyst),
                    showDismissButton: false
                )
                
                CatToastMsg(
                    "Toast with CatButton",
                    icon: Image("ic_check-circle-outlined-24", bundle: .catalyst),
                    showDismissButton: false
                ) {
                    CatButton(.text("Dismiss"), buttonSize: .extraSmall) {
                        print("Dismiss!")
                    }
                    .catButtonConfig(variant: .text, color: .primaryInverted)
                }
                
                CatToastMsg(
                    "Toast with CatButton",
                    icon: Image("ic_info-outlined-25", bundle: .catalyst)
                ) {
                    CatButton(.text("Dismiss"), buttonSize: .extraSmall) {
                        print("Dismiss!")
                    }
                    .catButtonConfig(variant: .text, color: .primaryInverted)
                }
                
                CatToastMsg(
                    "Toast with CatButton",
                    icon: Image("ic_info-outlined-25", bundle: .catalyst),
                ) {
                    CatButton(
                        .text("Dismiss"),
                        buttonSize: .extraSmall,
                        padding: EdgeInsets(
                            top: 0,
                            leading: 0,
                            bottom: 0,
                            trailing: 0
                        )
                    ) {
                        print("Dismiss!")
                    }
                    .catButtonConfig(variant: .text, color: .primaryInverted)
                }
                
                CatToastMsg(
                    "Toast with CatButton",
                    icon: Image("ic_info-outlined-25", bundle: .catalyst),
                    variant: .expanded
                ) {
                    CatButton(
                        .text("Dismiss"),
                        buttonSize: .custom(32),
                        padding: EdgeInsets(
                            top: 0,
                            leading: 0,
                            bottom: 0,
                            trailing: 0
                        )
                    ) {
                        print("Dismiss!")
                    }
                    .catButtonConfig(variant: .text, color: .primaryInverted)
                }
                
                CatToastMsg(
                    "Toast with CatButton",
                    icon: Image("ic_info-outlined-25", bundle: .catalyst),
                    variant: .expanded,
                    accessibilityIdentifier: "toast-expanded"
                ) {
                    CatButton(
                        .text("Dismiss"),
                        buttonSize: .extraSmall,
                        accessibilityIdentifier: "toast-expanded-dismiss"
                    ) {
                        print("Dismiss!")
                    }
                    .catButtonConfig(variant: .outlined, color: .primaryInverted)
                }
                
                CatToastMsg(
                    "Toast with Button",
                    icon: Image("ic_info-outlined-25", bundle: .catalyst),
                    variant: .expanded
                ) {
                    Button ("Action") {
                        print("Dismiss!")
                    }
                }
            }
        }
    }
}

#Preview {
    ToastMsgDemoView()
}
