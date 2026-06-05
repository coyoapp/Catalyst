//
//  CatAlertBuilder.swift
//  Catalyst
//

import SwiftUI

// ---------------------------------------------------------------------------
// CatAlert
//
// A card-style inline alert: a leading icon, a heading, and an optional trailing
// action button, inside a rounded card with a variant-colored border.
//
// The action button is laid out responsively (see CatAlertBuilder): it sits inline
// to the right of the heading when everything fits on one line, and drops below the
// heading when the heading is long enough to wrap.
//
// Color (border / heading / icon) is driven by the semantic `CatAlertVariant`, injected
// through the environment via `.catAlertConfig(variant:)`. The `.brand` variant supports
// whitelabeling via `.catalystAccentColor(_:)`.
//
// Accessibility: CatAlert deliberately does NOT set an `.accessibilityLabel`. The heading
// `Text` and the consumer's action button remain individually accessible so the consuming
// view can assign accessibility values appropriate to its context.
// ---------------------------------------------------------------------------

public struct CatAlert<Action: View>: View {
    private let heading: String
    private let icon: Image
    private let action: Action

    /// The active alert config from the environment. Set via `.catAlertConfig(variant:)`.
    @Environment(\.catAlertConfig) private var alertConfig
    /// The active Catalyst theme from the environment.
    @Environment(\.catalystTheme) private var theme
    /// An optional accent palette injected via `.catalystAccentColor(_:)`. Affects `.brand` only.
    @Environment(\.catalystAccentPalette) private var accentPalette

    /// Creates a `CatAlert` with a trailing action button.
    ///
    /// - Parameters:
    ///   - heading: The alert's heading text.
    ///   - icon: The leading icon. Defaults to the design system's info-circle, tinted to the
    ///     variant color. Pass any `Image` to override.
    ///   - action: A view (typically a `CatButton`) shown inline-trailing on short alerts and
    ///     below the heading on long ones.
    public init(
        _ heading: String,
        icon: Image = Image("ic_info-outlined-25", bundle: .catalyst),
        @ViewBuilder action: () -> Action
    ) {
        self.heading = heading
        self.icon = icon
        self.action = action()
    }

    public var body: some View {
        let config = CatTheme.alertConfig(
            variant: alertConfig.variant,
            theme: theme,
            accentPalette: accentPalette
        )
        CatAlertBuilder(heading: heading, icon: icon, config: config) {
            action
        }
    }
}

// MARK: - No-action-button convenience

public extension CatAlert where Action == EmptyView {
    /// Creates a `CatAlert` with only a leading icon and heading (no action button).
    ///
    /// - Parameters:
    ///   - heading: The alert's heading text.
    ///   - icon: The leading icon. Defaults to the design system's info-circle.
    init(
        _ heading: String,
        icon: Image = Image("ic_info-outlined-25", bundle: .catalyst)
    ) {
        self.init(heading, icon: icon) { EmptyView() }
    }
}

// ---------------------------------------------------------------------------
// CatAlertBuilder — internal layout
//
// Reads a resolved `CatAlertStyleConfig` and assembles the card. `ViewThatFits`
// chooses the inline layout when the icon + heading + button fit on one line and
// falls back to the stacked layout (button below) otherwise.
// ---------------------------------------------------------------------------

struct CatAlertBuilder<Action: View>: View {
    let heading: String
    let icon: Image
    let config: CatAlertStyleConfig
    @ViewBuilder let action: () -> Action

    var body: some View {
        ViewThatFits(in: .horizontal) {
            inlineLayout
            stackedLayout
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(CatSpacing.spacingLg)
        .background(config.colorStyle.background)
        .clipShape(RoundedRectangle(cornerRadius: config.cornerRadius))
        .overlay(
            RoundedRectangle(cornerRadius: config.cornerRadius)
                .strokeBorder(config.colorStyle.border.opacity(0.3), lineWidth: config.borderWidth)
        )
    }

    /// The leading icon, tinted to the variant color.
    private var iconView: some View {
        icon
            .resizable()
            .renderingMode(.template)
            .scaledToFit()
            .frame(width: CatSizes.sizeLg, height: CatSizes.sizeLg)
            .foregroundStyle(config.colorStyle.icon)
    }

    /// The heading text, colored to the variant.
    private var headingText: some View {
        Text(heading)
            .font(config.headingFont)
            .foregroundStyle(config.colorStyle.heading)
            .fixedSize(horizontal: false, vertical: true)
    }

    /// Single-line layout: icon + heading, then the action button pinned to the trailing edge.
    /// `.fixedSize()` keeps the button at its intrinsic width so `ViewThatFits` reports this
    /// candidate as "too wide" once the heading no longer fits on one line.
    private var inlineLayout: some View {
        HStack(alignment: .center, spacing: CatSpacing.spacingMd) {
            iconView
            headingText
            Spacer(minLength: CatSpacing.spacingMd)
            action()
                .fixedSize()
        }
    }

    /// Stacked layout: the icon stays in a leading column; the heading and the action button
    /// share the trailing column, so the button leading-aligns with the text (not the icon).
    /// `.fixedSize()` keeps the button at its intrinsic width instead of stretching the row.
    private var stackedLayout: some View {
        HStack(alignment: .top, spacing: CatSpacing.spacingMd) {
            iconView
            VStack(alignment: .leading, spacing: CatSpacing.spacingMd) {
                headingText
                action()
                    .fixedSize()
            }
        }
    }
}
