//
//  ButtonsDemoView.swift
//  CatalystDemo
//

import SwiftUI
import Catalyst

// ---------------------------------------------------------------------------
// ButtonsDemoView
//
// Demonstrates all CatButton variants, colors, sizes, content types,
// enabled/disabled states, full-width usage, and environment config injection.
// Mirrors the Android ButtonsDemoScreen as closely as SwiftUI idioms allow.
// ---------------------------------------------------------------------------

struct ButtonsDemoView: View {

    private let allColors: [CatTheme.ColorConfig] = [
        .primary, .primaryInverted, .secondary, .secondaryInverted,
        .danger, .success, .warning, .info,
    ]

    private let invertedColors: [CatTheme.ColorConfig] = [
        .primaryInverted, .secondaryInverted,
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: CatSpacing.spacingXl) {

                Text("Buttons")
                    .font(CatTypography.h2)

                // -----------------------------------------------------------
                // 1. Filled — all colors
                // -----------------------------------------------------------
                SectionHeader("Filled")
                ColorConfigRow(variant: .filled, colors: allColors)

                // -----------------------------------------------------------
                // 2. Outlined — all colors
                // -----------------------------------------------------------
                SectionHeader("Outlined")
                ColorConfigRow(variant: .outlined, colors: allColors)

                // -----------------------------------------------------------
                // 3. Text — all colors
                // -----------------------------------------------------------
                SectionHeader("Text")
                ColorConfigRow(variant: .text, colors: allColors)

                // -----------------------------------------------------------
                // 4. Link — all colors
                // -----------------------------------------------------------
                SectionHeader("Link")
                ColorConfigRow(variant: .link, colors: allColors)

                Divider()

                // -----------------------------------------------------------
                // 5. Inverted — on dark background
                // -----------------------------------------------------------
                SectionHeader("Inverted (on dark background)")
                VStack(alignment: .leading, spacing: CatSpacing.spacingMd) {
                    Text("PrimaryInverted + SecondaryInverted")
                        .font(CatTypography.s1)
                        .foregroundStyle(CatColors.Ui.Font.bodyInverted)
                    ColorConfigRow(variant: .filled,   colors: invertedColors)
                    ColorConfigRow(variant: .outlined,  colors: invertedColors)
                    ColorConfigRow(variant: .text,      colors: invertedColors)
                    ColorConfigRow(variant: .link,      colors: invertedColors)
                }
                .padding(CatSpacing.spacingXl)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(CatColors.Ui.Background.surfaceInverted)

                Divider()

                // -----------------------------------------------------------
                // 6. Sizes — ExtraSmall / Small / Medium
                //    (Android: Small/Medium/Large — iOS enum has no .large)
                // -----------------------------------------------------------
                SectionHeader("Sizes")
                HStack(spacing: CatSpacing.spacingMd) {
                    CatButton(.text("ExtraSmall"), buttonSize: .extraSmall) {}
                        .catButtonConfig(variant: .filled, color: .primary)
                    CatButton(.text("Small"), buttonSize: .small) {}
                        .catButtonConfig(variant: .filled, color: .primary)
                    CatButton(.text("Medium"), buttonSize: .medium) {}
                        .catButtonConfig(variant: .filled, color: .primary)
                }

                Divider()

                // -----------------------------------------------------------
                // 7. Icon + Text — leading and trailing placement
                // -----------------------------------------------------------
                SectionHeader("Icon + Text")
                HStack(spacing: CatSpacing.spacingMd) {
                    CatButton(
                        .iconText(icon: Image("icon-checkmark", bundle: .catalyst),
                                  text: "Leading",
                                  placement: .leading),
                        buttonSize: .medium
                    ) {}
                    .catButtonConfig(variant: .filled, color: .primary)

                    CatButton(
                        .iconText(icon: Image("icon-checkmark", bundle: .catalyst),
                                  text: "Trailing",
                                  placement: .trailing),
                        buttonSize: .medium
                    ) {}
                    .catButtonConfig(variant: .outlined, color: .primary)
                }
                HStack(spacing: CatSpacing.spacingMd) {
                    CatButton(
                        .iconText(icon: Image("icon-checkmark", bundle: .catalyst),
                                  text: "Success",
                                  placement: .leading),
                        buttonSize: .medium
                    ) {}
                    .catButtonConfig(variant: .filled, color: .success)

                    CatButton(
                        .iconText(icon: Image("icon-checkmark", bundle: .catalyst),
                                  text: "Danger",
                                  placement: .leading),
                        buttonSize: .medium
                    ) {}
                    .catButtonConfig(variant: .filled, color: .danger)
                }

                Divider()

                // -----------------------------------------------------------
                // 8. Icon Only
                // -----------------------------------------------------------
                SectionHeader("Icon Only")
                HStack(spacing: CatSpacing.spacingMd) {
                    CatButton(
                        .icon(Image("icon-checkmark", bundle: .catalyst)),
                        buttonSize: .medium
                    ) {}
                    .catButtonConfig(variant: .filled, color: .primary)

                    CatButton(
                        .icon(Image("icon-checkmark", bundle: .catalyst)),
                        buttonSize: .medium
                    ) {}
                    .catButtonConfig(variant: .outlined, color: .danger)

                    CatButton(
                        .icon(Image("icon-checkmark", bundle: .catalyst)),
                        buttonSize: .small
                    ) {}
                    .catButtonConfig(variant: .text, color: .success)
                }

                Divider()

                // -----------------------------------------------------------
                // 9. Full Width
                // -----------------------------------------------------------
                SectionHeader("Full Width")
                CatButton(.text("Full Width — Primary Filled"), buttonSize: .medium) {}
                    .catButtonConfig(variant: .filled, color: .primary)
                    .frame(maxWidth: .infinity)

                CatButton(
                    .iconText(icon: Image("icon-checkmark", bundle: .catalyst),
                              text: "Full Width — Danger Outlined",
                              placement: .leading),
                    buttonSize: .medium
                ) {}
                .catButtonConfig(variant: .outlined, color: .danger)
                .frame(maxWidth: .infinity)

                CatButton(.text("Full Width — Success Text"), buttonSize: .medium) {}
                    .catButtonConfig(variant: .text, color: .success)
                    .frame(maxWidth: .infinity)

                Divider()

                // -----------------------------------------------------------
                // 10. Disabled — one per variant
                // -----------------------------------------------------------
                SectionHeader("Disabled")
                HStack(spacing: CatSpacing.spacingMd) {
                    CatButton(.text("Filled"), buttonSize: .medium) {}
                        .catButtonConfig(variant: .filled, color: .primary)
                        .disabled(true)

                    CatButton(.text("Outlined"), buttonSize: .medium) {}
                        .catButtonConfig(variant: .outlined, color: .primary)
                        .disabled(true)

                    CatButton(.text("Text"), buttonSize: .medium) {}
                        .catButtonConfig(variant: .text, color: .primary)
                        .disabled(true)

                    CatButton(.text("Link"), buttonSize: .medium) {}
                        .catButtonConfig(variant: .link, color: .primary)
                        .disabled(true)
                }

                Divider()

                // -----------------------------------------------------------
                // 11. catButtonConfig — environment injection demo
                // -----------------------------------------------------------
                SectionHeader("catButtonConfig (environment)")
                Text("All buttons inside the modifier inherit Outlined + Warning without explicit params.")
                    .font(CatTypography.body2)

                // Apply config to the parent — child buttons inherit it
                HStack(spacing: CatSpacing.spacingMd) {
                    CatButton(.text("Button A"), buttonSize: .medium) {}
                    CatButton(.text("Button B"), buttonSize: .medium) {}
                    // Override just the color at the call site
                    CatButton(.text("Override"), buttonSize: .medium) {}
                        .catButtonConfig(variant: .outlined, color: .info)
                }
                .catButtonConfig(variant: .outlined, color: .warning)

                Spacer(minLength: CatSpacing.spacing4xl)
            }
            .padding(.horizontal, CatSpacing.spacingMd)
            .padding(.vertical, CatSpacing.spacing2xl)
        }
        .navigationTitle("Buttons")
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

/// Renders a wrapping row of buttons — one per color — all sharing the same variant.
private struct ColorConfigRow: View {
    let variant: CatTheme.ButtonVariant
    let colors: [CatTheme.ColorConfig]

    var body: some View {
        // SwiftUI doesn't have FlowRow natively pre-iOS 16 Layout protocol.
        // We use a simple wrapping layout via WrappingHStack helper below.
        WrappingHStack(spacing: CatSpacing.spacingMd) {
            ForEach(colors, id: \.self) { color in
                CatButton(.text(color.label), buttonSize: .medium) {}
                    .catButtonConfig(variant: variant, color: color)
            }
        }
    }
}

private extension CatTheme.ColorConfig {
    /// Human-readable label matching Android's `color.name`.
    var label: String {
        switch self {
        case .primary:           return "Primary"
        case .primaryInverted:   return "PrimaryInverted"
        case .secondary:         return "Secondary"
        case .secondaryInverted: return "SecondaryInverted"
        case .danger:            return "Danger"
        case .success:           return "Success"
        case .warning:           return "Warning"
        case .info:              return "Info"
        }
    }
}

// ---------------------------------------------------------------------------
// WrappingHStack
// A minimal flow-layout that wraps children when they exceed the available width.
// ---------------------------------------------------------------------------

private struct WrappingHStack: Layout {
    var spacing: CGFloat

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let maxWidth = proposal.width ?? .infinity
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > maxWidth, x > 0 {
                y += rowHeight + spacing
                x = 0
                rowHeight = 0
            }
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
        y += rowHeight
        return CGSize(width: maxWidth, height: y)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let maxWidth = bounds.maxX
        var x = bounds.minX
        var y = bounds.minY
        var rowHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > maxWidth, x > bounds.minX {
                y += rowHeight + spacing
                x = bounds.minX
                rowHeight = 0
            }
            subview.place(at: CGPoint(x: x, y: y), proposal: .unspecified)
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
    }
}

#Preview {
    NavigationStack {
        ButtonsDemoView()
    }
}
