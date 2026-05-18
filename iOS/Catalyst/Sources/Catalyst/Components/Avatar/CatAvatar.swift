//
//  CatAvatar.swift
//  Catalyst
//

import SwiftUI
import Kingfisher

public struct CatAvatar: View {

    // MARK: Properties
    private let initials: String?
    private let imageURL: URL?
    private let backgroundColor: Color?
    private let font: Font

    // MARK: Constants
    private let size: CGFloat = CatSizes.size4xl

    // MARK: Init
    public init(
        initials: String?,
        imageURL: URL?,
        backgroundColor: Color?,
        font: Font = CatTypography.s1
    ) {
        self.initials = initials
        self.imageURL = imageURL
        self.backgroundColor = backgroundColor
        self.font = font
    }

    // MARK: Body
    public var body: some View {
        Group {
            if let url = imageURL {
                KFImage(url)
                    .resizable()
                    .placeholder { placeholder }
                    .scaledToFill()
            } else {
                placeholder
            }
        }
        .frame(width: size, height: size)
        .clipShape(Circle())
    }

    // MARK: Placeholder
    private var placeholder: some View {
        ZStack {
            (backgroundColor ?? CatColors.Ui.Background.muted)
            if let text = initials?.uppercased(), !text.isEmpty {
                Text(text)
                    .font(font)
                    .foregroundStyle(CatColors.Ui.Font.tooltip)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
            }
        }
    }
}
// MARK: - Preview

#Preview("With initials") {
    HStack(spacing: CatSpacing.spacingXl) {
        CatAvatar(initials: "AB", imageURL: nil, backgroundColor: CatColors.Theme.Primary.fill)
        CatAvatar(initials: "CD", imageURL: nil, backgroundColor: CatColors.Theme.Danger.fill)
        CatAvatar(initials: "EF", imageURL: nil, backgroundColor: CatColors.Theme.Success.fill)
        CatAvatar(initials: nil,  imageURL: nil, backgroundColor: nil)
    }
    .padding()
    .background(CatColors.Ui.Background.canvas)
}

#Preview("Font sizes") {
    HStack(spacing: CatSpacing.spacingXl) {
        CatAvatar(initials: "AB", imageURL: nil, backgroundColor: CatColors.Theme.Primary.fill)
        CatAvatar(initials: "AB", imageURL: nil, backgroundColor: CatColors.Theme.Primary.fill)
        CatAvatar(initials: "AB", imageURL: nil, backgroundColor: CatColors.Theme.Primary.fill)
        CatAvatar(initials: "AB", imageURL: nil, backgroundColor: CatColors.Theme.Primary.fill)
    }
    .padding()
    .background(CatColors.Ui.Background.canvas)
}
