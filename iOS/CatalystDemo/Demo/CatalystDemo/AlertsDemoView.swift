//
//  AlertsDemoView.swift
//  CatalystDemo
//

import SwiftUI
import Catalyst

// ---------------------------------------------------------------------------
// AlertsDemoView
//
// Demonstrates all CatAlert variants in three forms:
//   • short heading      → action button sits inline to the right
//   • long heading       → action button wraps below the heading
//   • no action button   → icon + heading only
// Plus a custom-icon example and the .brand whitelabel (accent) path.
// Mirrors the structure of ButtonsDemoView.
// ---------------------------------------------------------------------------

struct AlertsDemoView: View {

    private let allVariants: [CatAlertVariant] = CatAlertVariant.allCases

    private let shortHeading = "Heading"
    private let longHeading =
        "Heading that is a bit longer and so if we need more lines"

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: CatSpacing.spacingXl) {

                Text("Alerts")
                    .font(CatTypography.h2)

                // -----------------------------------------------------------
                // 1. Short heading — action button inline-trailing
                // -----------------------------------------------------------
                SectionHeader("Short heading (button inline)")
                ForEach(allVariants, id: \.self) { variant in
                    CatAlert(shortHeading) {
                        demoActionButton
                    }
                    .catAlertConfig(variant: variant)
                }

                Divider()

                // -----------------------------------------------------------
                // 2. Long heading — action button wraps below
                // -----------------------------------------------------------
                SectionHeader("Long heading (button wraps below)")
                ForEach(allVariants, id: \.self) { variant in
                    CatAlert(longHeading) {
                        demoActionButton
                    }
                    .catAlertConfig(variant: variant)
                }

                Divider()

                // -----------------------------------------------------------
                // 3. No action button
                // -----------------------------------------------------------
                SectionHeader("No action button")
                ForEach(allVariants, id: \.self) { variant in
                    CatAlert(shortHeading)
                        .catAlertConfig(variant: variant)
                }

                Divider()

                // -----------------------------------------------------------
                // 4. Custom icon override
                // -----------------------------------------------------------
                SectionHeader("Custom icon")
                CatAlert(
                    "Custom leading icon",
                    icon: Image("icon-checkmark", bundle: .catalyst)
                ) {
                    demoActionButton
                }
                .catAlertConfig(variant: .success)

                Divider()

                // -----------------------------------------------------------
                // 5. Brand variant — whitelabel via accent color
                // -----------------------------------------------------------
                SectionHeader("Brand variant + accent (whitelabel)")
                CatAlert("Brand alert (default Primary)") {
                    demoActionButton
                }
                .catAlertConfig(variant: .brand)

                CatAlert("Brand alert (custom accent)") {
                    demoActionButton
                }
                .catAlertConfig(variant: .brand)
                .catalystAccentColor(Color(red: 0.40, green: 0.30, blue: 0.92))

                Spacer(minLength: CatSpacing.spacing4xl)
            }
            .padding(.horizontal, CatSpacing.spacingMd)
            .padding(.vertical, CatSpacing.spacing2xl)
        }
        .navigationTitle("Alerts")
        .navigationBarTitleDisplayMode(.inline)
    }

    /// The trailing action button used across the demo — Secondary / Outlined / small,
    /// matching the design's component properties. Kept at intrinsic width so the responsive
    /// layout works.
    private var demoActionButton: some View {
        CatButton(.text("Button"), buttonSize: .small) {}
            .catButtonConfig(variant: .outlined, color: .secondary)
    }
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

private struct SectionHeader: View {
    let title: String
    init(_ title: String) { self.title = title }

    var body: some View {
        Text(title)
            .font(CatTypography.s1)
    }
}

#Preview {
    NavigationStack {
        AlertsDemoView()
    }
}
