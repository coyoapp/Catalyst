//
//  CatListBuilder.swift
//  Catalyst
//
//  Created by Efe Durmaz on 04.05.26.
//

import SwiftUI

// MARK: - CatList (Container)

/// A container that renders a group of navigation list items with automatic
/// position assignment, divider insertion, and shared corner-radius clipping.
///
/// Usage:
/// ```swift
/// CatList(items: [
///     (.listItem(icon: Image("icon"), title: "Bookmarks", newItemIndicator: false), { }),
///     (.listItem(icon: Image("icon"), title: "Settings",  newItemIndicator: true),  { }),
/// ])
/// ```
public struct CatList: View {
    public let items: [(content: CatListContent, action: () -> Void)]
    public let styleConfig: CatListStateStyleConfig

    public init(
        items: [(content: CatListContent, action: () -> Void)],
        styleConfig: CatListStateStyleConfig = CatTheme.listConfig()
    ) {
        self.items = items
        self.styleConfig = styleConfig
    }

    public var body: some View {
        VStack(spacing: 0) {
            ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                CatListBuilder(
                    content: item.content,
                    position: position(at: index),
                    styleConfig: styleConfig,
                    action: item.action
                )
            }
        }
        // Outer clip ensures group corners are always respected even when
        // CatListStyle clips individual rows with UnevenRoundedRectangle.
        .clipShape(RoundedRectangle(cornerRadius: CatBorderRadius.borderRadiusMd))
    }

    // MARK: Position resolution

    private func position(at index: Int) -> CatListPosition {
        let count = items.count
        guard count > 1 else { return .standalone }
        if index == 0 { return .top }
        if index == count - 1 { return .bottom }
        return .middle
    }
}

// MARK: - CatListBuilder (Single Row)

/// A single tappable navigation row. Handles icon, title (+ optional subtitle),
/// new-item indicator dot, chevron, and inter-row divider placement.
///
/// Colors are driven by `CatListStateStyleConfig` — `CatListStyle` resolves the
/// active interaction state and injects the winning `CatListStateColorStyle` into
/// `@Environment(\.catListResolvedStyle)`, which each sub-view reads directly.
///
/// Prefer using `CatList` when composing multiple rows; use `CatListBuilder`
/// directly only for a single isolated row.
public struct CatListBuilder: View {

    let content: CatListContent
    let position: CatListPosition
    let styleConfig: CatListStateStyleConfig
    let action: () -> Void

    public init(
        content: CatListContent,
        position: CatListPosition = .standalone,
        styleConfig: CatListStateStyleConfig = CatTheme.listConfig(),
        action: @escaping () -> Void
    ) {
        self.content = content
        self.position = position
        self.styleConfig = styleConfig
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            RowContent(content: content, position: position)
        }
        .buttonStyle(CatListStyle(styleConfig: styleConfig, position: position))
    }
}

// MARK: - Row Content

/// Internal view that builds the row layout and reads all colors from
/// `@Environment(\.catListResolvedStyle)`, which is injected by `CatListStyle`.
private struct RowContent: View {

    let content: CatListContent
    let position: CatListPosition

    @Environment(\.catListResolvedStyle) private var colors

    var body: some View {
        switch content {

        case .listItem(let icon, let title, let newItemIndicator):
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    leadingIcon(icon)
                    HStack(spacing: CatSpacing.spacingMd) {
                        Text(title)
                            .font(CatTypography.body1)
                            .foregroundStyle(colors.text)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        trailingCluster(newItemIndicator: newItemIndicator.wrappedValue)
                    }
                    .padding(.vertical, CatSpacing.spacingXl)
                    .padding(.trailing, CatSpacing.spacingXl)
                }
                if position.showDivider {
                    dividerLine()
                        .padding(.trailing, CatSpacing.spacingXl)
                        .padding(.leading, CatSpacing.spacing7xl)
                }
            }
            .frame(minHeight: CatListSize.regular.height)

        case .avatarListItem(let initials, let imageURL, let color, let title, let subtitle, let newItemIndicator):
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    leadingAvatar(initials: initials, imageURL: imageURL, color: color)
                    HStack(spacing: CatSpacing.spacingMd) {
                        VStack {
                            Text(title)
                                .font(CatTypography.body1)
                                .foregroundStyle(colors.text)
                                .lineLimit(1)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            if let subtitle = subtitle {
                                Text(subtitle)
                                    .font(CatTypography.body2)
                                    .foregroundStyle(colors.subtitle)
                                    .lineLimit(1)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        trailingCluster(newItemIndicator: newItemIndicator.wrappedValue)
                    }
                    .padding(.vertical, CatSpacing.spacingXl)
                    .padding(.trailing, CatSpacing.spacingXl)
                }
                if position.showDivider {
                    dividerLine()
                        .padding(.trailing, CatSpacing.spacingXl)
                        .padding(.leading, CatSpacing.spacing7xl)
                }
            }
            .frame(minHeight: CatListSize.medium.height)
        }
    }

    // MARK: Sub-views

    /// Leading icon with symmetric padding so the icon column has a consistent width.
    private func leadingIcon(_ icon: Image) -> some View {
        icon
            .renderingMode(.template)
            .foregroundStyle(colors.icon)
            .padding(.vertical, CatSpacing.spacingLg)
            .padding(.leading, CatSpacing.spacingXl)
            .padding(.trailing, CatSpacing.spacingXl)
    }

    /// Leading avatar with the same padding geometry as `leadingIcon`.
    private func leadingAvatar(initials: String?, imageURL: URL?, color: Color?) -> some View {
        CatAvatar(initials: "\(initials ?? "")", imageURL: imageURL, color: color)
            .padding(.vertical, CatSpacing.spacingLg)
            .padding(.leading, CatSpacing.spacingXl)
            .padding(.trailing, CatSpacing.spacingXl)
    }

    /// New-item ellipse dot + chevron on the trailing edge.
    private func trailingCluster(newItemIndicator: Bool) -> some View {
        HStack(spacing: CatSpacing.spacingXs) {
            if newItemIndicator {
                Image("ellipse-1", bundle: .catalyst)
                    .renderingMode(.template)
                    .foregroundStyle(colors.ellipse)
            }

            Image("chevron-right-outlined", bundle: .catalyst)
                .renderingMode(.template)
                .foregroundStyle(colors.chevron)
        }
    }

    /// A 1-pt horizontal line spanning only the text/trailing column (not under the icon).
    private func dividerLine() -> some View {
        Divider()
    }
}

// MARK: - Preview
#Preview("Group — 3 items") {
    CatList(items: [
        (
            .listItem(
                icon: Image("bookmarks-outlined-25", bundle: .catalyst),
                title: "Bookmarks",
                newItemIndicator: .constant(false)
            ),
            {}
        ),
        (
            .listItem(
                icon: Image("pages-outlined-25", bundle: .catalyst),
                title: "Pages",
                newItemIndicator: .constant(true)
            ),
            {}
        ),
        (
            .listItem(
                icon: Image("communities-outlined-25", bundle: .catalyst),
                title: "Communities",
                newItemIndicator: .constant(false)
            ),
            {}
        ),
    ])
    .padding()
    .background(CatColors.Ui.Background.canvas)
}

#Preview("Disabled") {
    CatList(items: [
        (
            .listItem(
                icon: Image("bookmarks-outlined-25", bundle: .catalyst),
                title: "Bookmarks",
                newItemIndicator: .constant(false)
            ),
            {}
        ),
        (
            .listItem(
                icon: Image("communities-outlined-25", bundle: .catalyst),
                title: "Communities",
                newItemIndicator: .constant(true)
            ),
            {}
        ),
    ])
    .disabled(true)
    .padding()
    .background(CatColors.Ui.Background.canvas)
}

#Preview("Mixed — icon and avatar rows") {
    CatList(items: [
        (
            .listItem(
                icon: Image("bookmarks-outlined-25", bundle: .catalyst),
                title: "Bookmarks",
                newItemIndicator: .constant(false)
            ),
            {}
        ),
        (
            .avatarListItem(
                initials: "AB",
                imageURL: nil,
                color: CatColors.Theme.Primary.fill,
                title: "Alice Brown",
                subtitle: "iOS Developer",
                newItemIndicator: .constant(true)
            ),
            {}
        ),
        (
            .avatarListItem(
                initials: "CD",
                imageURL: nil,
                color: CatColors.Theme.Danger.fill,
                title: "Chris Doe",
                subtitle: nil,
                newItemIndicator: .constant(false)
            ),
            {}
        ),
        (
            .listItem(
                icon: Image("communities-outlined-25", bundle: .catalyst),
                title: "Communities",
                newItemIndicator: .constant(false)
            ),
            {}
        ),
    ])
    .padding()
    .background(CatColors.Ui.Background.canvas)
}
