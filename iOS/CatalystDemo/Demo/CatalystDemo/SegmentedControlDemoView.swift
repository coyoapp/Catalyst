//
//  SegmentedControlDemoView.swift
//  CatalystDemo
//

import SwiftUI
import Catalyst

// ---------------------------------------------------------------------------
// SegmentedControlDemoView
//
// Demonstrates CatSegmentedControl:
//   • two segments with a live selection readout
//   • three segments
//   • whitelabel (accent color) — selected label takes the accent, pill stays white
//   • disabled
// Mirrors the structure of AlertsDemoView.
// ---------------------------------------------------------------------------

struct SegmentedControlDemoView: View {

    @State private var twoSegmentSelection = 0
    @State private var threeSegmentSelection = 0
    @State private var accentSelection = 0
    @State private var disabledSelection = 0

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: CatSpacing.spacingXl) {

                Text("Segmented control")
                    .font(CatTypography.h2)

                // -----------------------------------------------------------
                // 1. Two segments + selection readout
                // -----------------------------------------------------------
                SectionHeader("Two segments")
                CatSegmentedControl(["Option 1", "Option 2"], selection: $twoSegmentSelection)
                Text("Selected index: \(twoSegmentSelection)")
                    .font(CatTypography.body2)
                    .foregroundStyle(CatColors.Ui.Font.muted)

                Divider()

                // -----------------------------------------------------------
                // 2. Three segments
                // -----------------------------------------------------------
                SectionHeader("Three segments")
                CatSegmentedControl(
                    ["Summarize", "Explain", "Translate"],
                    selection: $threeSegmentSelection
                )

                Divider()

                // -----------------------------------------------------------
                // 3. Whitelabel via accent color
                // -----------------------------------------------------------
                SectionHeader("Accent color (whitelabel)")
                CatSegmentedControl(["Option 1", "Option 2"], selection: $accentSelection)
                    .catalystAccentColor(Color(red: 0.40, green: 0.30, blue: 0.92))

                Divider()

                // -----------------------------------------------------------
                // 4. Disabled
                // -----------------------------------------------------------
                SectionHeader("Disabled")
                CatSegmentedControl(["Option 1", "Option 2"], selection: $disabledSelection)
                    .disabled(true)
                    .opacity(0.5)

                Spacer(minLength: CatSpacing.spacing4xl)
            }
            .padding(.horizontal, CatSpacing.spacingMd)
            .padding(.vertical, CatSpacing.spacing2xl)
        }
        .navigationTitle("Segmented control")
        .navigationBarTitleDisplayMode(.inline)
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
        SegmentedControlDemoView()
    }
}
