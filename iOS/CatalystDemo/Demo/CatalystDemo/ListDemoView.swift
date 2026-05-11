//
//  ListDemoView.swift
//  CatalystDemo
//

import SwiftUI
import Catalyst

// MARK: - Destination registry

/// All screens reachable from the list demo.
enum ListDemoDestination: Hashable, Identifiable {
    case pagesList
    case people
    case profile
    case settings
    var id: Self { self }
}

// MARK: - ListDemoView

struct ListDemoView: View {

    @State private var destination: ListDemoDestination?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: CatSpacing.spacing3xl) {

                // ── Section 1: Standalone (single item) ──────────────────────
                SectionHeader("Standalone — single item")

                CatList(items: [
                    (
                        .listItem(
                            icon: Image("ic_pages-outlined-25", bundle: .catalyst),
                            title: "Pages",
                            newItemIndicator: .constant(false)
                        ),
                        { destination = .pagesList }
                    ),
                ])

                // ── Section 2: Two-item group (top + bottom) ──────────────────
                SectionHeader("Two items — top / bottom")

                CatList(items: [
                    (
                        .listItem(
                            icon: Image("collagues-outlined-25", bundle: .catalyst),
                            title: "People",
                            newItemIndicator: .constant(true)
                        ),
                        { destination = .people }
                    ),
                    (
                        .listItem(
                            icon: Image("ic_settings-outlined-25", bundle: .catalyst),
                            title: "Settings",
                            newItemIndicator: .constant(false)
                        ),
                        { destination = .settings }
                    ),
                ])

                // ── Section 3: Full group (top / middle / bottom) ─────────────
                SectionHeader("Full group — top / middle / bottom")

                CatList(items: [
                    (
                        .listItem(
                            icon: Image("collagues-outlined-25", bundle: .catalyst),
                            title: "Pages",
                            newItemIndicator: .constant(false)
                        ),
                        { destination = .pagesList }
                    ),
                    (
                        .listItem(
                            icon: Image("ic_pages-outlined-25", bundle: .catalyst),
                            title: "People",
                            newItemIndicator: .constant(true)
                        ),
                        { destination = .people }
                    ),
                    (
                        .listItem(
                            icon: Image("ic_settings-outlined-25", bundle: .catalyst),
                            title: "Settings",
                            newItemIndicator: .constant(false)
                        ),
                        { destination = .settings }
                    ),
                ])
                Spacer(minLength: CatSpacing.spacing4xl)
            }
            .padding(.horizontal, CatSpacing.spacingXl)
            .padding(.vertical, CatSpacing.spacing2xl)
            .background(CatColors.Ui.Background.canvas)
            .navigationTitle("List")
            .navigationBarTitleDisplayMode(.inline)
            // ── Navigation destinations ───────────────────────────────────────────
            .navigationDestination(item: $destination) { dest in
                switch dest {
                case .pagesList: PagesListScreen()
                case .people: PeopleScreen()
                case .profile: ProfileScreen()
                case .settings: SettingsScreen()
                }
            }
        }
    }

    // MARK: - Destination placeholder screens

    /// Generic placeholder used for all demo destinations.
    private struct PlaceholderScreen: View {
        let title: String
        let systemImage: String

        var body: some View {
            VStack(spacing: CatSpacing.spacingXl) {
                Image(systemName: systemImage)
                    .font(.system(size: 56))
                    .foregroundStyle(CatColors.Theme.Primary.bg)
                Text(title)
                    .font(CatTypography.h3)
                    .foregroundStyle(CatColors.Ui.Font.head)
                Text("This is where the \(title) screen would live.")
                    .font(CatTypography.body1)
                    .foregroundStyle(CatColors.Ui.Font.muted)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, CatSpacing.spacing4xl)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(CatColors.Ui.Background.canvas)
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private struct PagesListScreen: View {
        var body: some View { PlaceholderScreen(title: "Pages", systemImage: "doc.text") }
    }

    private struct PeopleScreen: View {
        var body: some View { PlaceholderScreen(title: "People", systemImage: "person.2") }
    }

    private struct ProfileScreen: View {
        var body: some View { PlaceholderScreen(title: "Profile", systemImage: "person.circle") }
    }

    private struct SettingsScreen: View {
        var body: some View { PlaceholderScreen(title: "Settings", systemImage: "gearshape") }
    }
}

// MARK: - Helpers

private struct SectionHeader: View {
    let title: String
    init(_ title: String) { self.title = title }
    var body: some View {
        Text(title)
            .font(CatTypography.s1)
            .foregroundStyle(CatColors.Ui.Font.muted)
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        ListDemoView()
    }
}
