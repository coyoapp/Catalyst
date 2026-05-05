//
//  SwiftUIView.swift
//  Catalyst
//
//  Created by Efe Durmaz on 04.05.26.
//

import SwiftUI

struct CatList: View {
    var body: some View {
        VStack {
            CatListItem()
            
            CatListBuilder(
                content: .listItem(icon: Image("bookmarks-outlined-25", bundle: .catalyst),
                                   title: "Bookmark",
                                   newItemIndicator: false)) {
                                       print("Navigate")
                                   }
            
            CatListBuilder(
                content: .specialWithSubtitle(icon: Image("Avatar", bundle: .catalyst),
                                              title: "Robert Lang",
                                              subtitle: "Subtitle",
                                              newItemIndicator: false)) {
                                       print("Navigate")
                                   }
        }
        .background(CatColors.Theme.Primary.fill)
        .clipShape(RoundedRectangle(cornerRadius: CatBorderRadius.borderRadiusMd))
    }
}

// MARK: - CatList Items
struct CatListItem: View {
    var body: some View {
        Image("Avatar", bundle: .catalyst)
            .resizable()
            .renderingMode(.template)
            .frame(width: CatSizes.sizeMd, height: CatSizes.sizeMd)
    }
}

// MARK: - List Layout
public struct CatListBuilder: View {
    let content: CatListContent
    let action: () -> Void
    let iconSize: CGSize?
    let stackSpacing: CGFloat?
    
    public init(
        content: CatListContent,
        iconSize: CGSize? = CGSize(width: CatSizes.sizeMd, height: CatSizes.sizeMd),
        stackSpacing: CGFloat? = CatSpacing.spacingMd,
        action: @escaping () -> Void
    ) {
        self.content = content
        self.iconSize = iconSize
        self.action = action
        self.stackSpacing = stackSpacing
    }
    
    public var body: some View {
        Button(action: action) {
            buildContent()
        }
    }
    
    @ViewBuilder
    private func buildContent() -> some View {
        switch content {
        case .listItem(icon: let img, title: let title, newItemIndicator: false):
            HStack {
                HStack {
                    img
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: CatSizes.sizeMd, height: CatSizes.sizeMd)
                    
                    VStack {
                        Text(title)
                    }
                }
                
                Spacer()
                
                HStack {
                    Image("ellipse-1", bundle: .catalyst)
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: CatSizes.sizeXs, height: CatSizes.sizeXs)
                        .foregroundStyle(CatColors.Theme.Danger.bg)
                    
                    Image("chevron-right-outlined", bundle: .catalyst)
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: CatSizes.sizeMd, height: CatSizes.sizeMd)
                }
            }
        case .specialWithSubtitle(icon: let img, title: let title, subtitle: let subtitle, newItemIndicator: false):
            HStack {
                HStack {
                    img
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: CatSizes.sizeXl, height: CatSizes.sizeXl)
                    
                    VStack(alignment: .leading) {
                        Text(title)
                            .font(CatTypography.body1)
                        Text(subtitle)
                            .font(CatTypography.body2)
                    }
                }
                
                Spacer()
                
                HStack {
                    Image("ellipse-1", bundle: .catalyst)
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: CatSizes.sizeXs, height: CatSizes.sizeXs)
                        .foregroundStyle(CatColors.Theme.Danger.bg)
                    
                    Image("chevron-right-outlined", bundle: .catalyst)
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: CatSizes.sizeMd, height: CatSizes.sizeMd)
                }
            }
        default:
            EmptyView()
        }
    }
    
    private func iconView(_ icon: Image) -> some View {
        icon.resizable()
            .renderingMode(.template)
            .scaledToFit()
            .frame(width: iconSize?.width ?? CatSizes.sizeMd, height: iconSize?.height ?? CatSizes.sizeMd)
    }
}

#Preview {
    CatList()
}

