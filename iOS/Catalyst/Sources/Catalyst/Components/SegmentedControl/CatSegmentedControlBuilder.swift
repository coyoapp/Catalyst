//
//  CatSegmentedControlBuilder.swift
//  Catalyst
//

import SwiftUI

// ---------------------------------------------------------------------------
// CatSegmentedControl
//
// A horizontal control of N equal-width, mutually-exclusive segments on a muted
// track. The selected segment renders as a white pill (semibold, primary-colored
// label) that slides between segments on selection change; unselected segments
// show a muted regular label.
//
// Selection is a plain index binding — the consumer owns the state:
//
//     @State private var selected = 0
//     CatSegmentedControl(["Summarize", "Explain"], selection: $selected)
//
// Whitelabeling: `.catalystAccentColor(_:)` recolors the selected label; the
// pill itself stays white (accent palettes keep `fill = .white`), matching the
// design intent.
// ---------------------------------------------------------------------------

public struct CatSegmentedControl: View {
    private let segments: [String]
    @Binding private var selection: Int

    /// The active Catalyst theme from the environment.
    @Environment(\.catalystTheme) private var theme
    /// An optional accent palette injected via `.catalystAccentColor(_:)`.
    @Environment(\.catalystAccentPalette) private var accentPalette

    /// Creates a `CatSegmentedControl`.
    ///
    /// - Parameters:
    ///   - segments: The segment titles, rendered left to right.
    ///   - selection: The index of the selected segment. Out-of-range values render
    ///     with no selection pill until the user taps a segment.
    public init(_ segments: [String], selection: Binding<Int>) {
        self.segments = segments
        self._selection = selection
    }

    public var body: some View {
        let config = CatTheme.segmentedControlConfig(
            theme: theme,
            accentPalette: accentPalette
        )
        CatSegmentedControlBuilder(
            segments: segments,
            selection: $selection,
            config: config
        )
    }
}

// ---------------------------------------------------------------------------
// CatSegmentedControlBuilder — internal layout
//
// Reads a resolved `CatSegmentedControlStyleConfig` and assembles the track.
// The selection pill is a single `matchedGeometryEffect` shape, so it slides
// between segments instead of cross-fading.
// ---------------------------------------------------------------------------

struct CatSegmentedControlBuilder: View {
    let segments: [String]
    @Binding var selection: Int
    let config: CatSegmentedControlStyleConfig

    @Namespace private var pillNamespace

    var body: some View {
        HStack(spacing: 0) {
            ForEach(segments.indices, id: \.self) { index in
                segmentButton(at: index)
            }
        }
        .padding(config.trackPadding)
        .background(config.trackBackground)
        .clipShape(RoundedRectangle(cornerRadius: config.trackCornerRadius))
        .accessibilityElement(children: .contain)
    }

    private func segmentButton(at index: Int) -> some View {
        let isSelected = index == selection

        return Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                selection = index
            }
        } label: {
            Text(segments[index])
                .font(isSelected ? config.selectedFont : config.unselectedFont)
                .foregroundStyle(isSelected ? config.selectedText : config.unselectedText)
                .lineLimit(1)
                .padding(.horizontal, CatSpacing.spacingXl)
                .frame(maxWidth: .infinity)
                .frame(height: config.segmentHeight)
                .background {
                    if isSelected {
                        RoundedRectangle(cornerRadius: config.segmentCornerRadius)
                            .fill(config.selectedBackground)
                            .matchedGeometryEffect(id: "pill", in: pillNamespace)
                    }
                }
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

// MARK: - Previews

#Preview("Two segments") {
    VStack(spacing: CatSpacing.spacingXl) {
        StatefulPreviewWrapper(0) { selection in
            CatSegmentedControl(["Option 1", "Option 2"], selection: selection)
        }
        StatefulPreviewWrapper(1) { selection in
            CatSegmentedControl(["Option 1", "Option 2"], selection: selection)
        }
    }
    .padding()
}

#Preview("Three segments") {
    StatefulPreviewWrapper(0) { selection in
        CatSegmentedControl(["Summarize", "Explain", "Translate"], selection: selection)
    }
    .padding()
}

#Preview("Accent (whitelabel)") {
    StatefulPreviewWrapper(0) { selection in
        CatSegmentedControl(["Option 1", "Option 2"], selection: selection)
            .catalystAccentColor(Color(red: 0.40, green: 0.30, blue: 0.92))
    }
    .padding()
}

/// Tiny helper so `#Preview` blocks can drive a `Binding` interactively.
private struct StatefulPreviewWrapper<Content: View>: View {
    @State private var value: Int
    private let content: (Binding<Int>) -> Content

    init(_ initialValue: Int, @ViewBuilder content: @escaping (Binding<Int>) -> Content) {
        self._value = State(initialValue: initialValue)
        self.content = content
    }

    var body: some View {
        content($value)
    }
}
