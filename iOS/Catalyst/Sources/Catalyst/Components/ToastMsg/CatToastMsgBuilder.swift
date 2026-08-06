//
//  CatToastMsgBuilder.swift
//  Catalyst
//
//  Created by Catalyst Agent on 2026-07-21.
//
//  Display profile — config passed directly, no Button wrapper.
//  Reference: CatAlertBuilder.swift
//

import SwiftUI

// ---------------------------------------------------------------------------
// CatToastMsg
//
// A floating toast notification that appears at the bottom of the screen.
// The surface is display-only; the optional action slot and the internal
// dismiss button are the only interactive elements.
//
// Layout variants (set via `.catToastMsgConfig(variant:)`):
//   - compact:  Single row — icon? + title + action? + dismiss?  (fixed 56 pt height)
//   - expanded: Stacked   — icon? + VStack { title, action? } + dismiss? (top-right)
//
// Width: fills available width (.infinity). Always dark surface + inverted text.
// Action text color uses primaryInverted.text, accent-overridable for whitelabeling.
//
// Accessibility: CatToastMsg does NOT set an accessibilityLabel on the container.
// The title Text and the consumer's action slot remain individually accessible.
// ---------------------------------------------------------------------------

public struct CatToastMsg<Action: View>: View {
    private let title: String
    private let icon: Image?
    private let accessibilityIdentifier: String?
    private let showDismissButton: Bool
    private let onDismiss: (() -> Void)?
    private let action: Action

    /// The active Catalyst theme from the environment.
    @Environment(\.catalystTheme) private var theme
    /// An optional accent palette injected via `.catalystAccentColor(_:)`.
    @Environment(\.catalystAccentPalette) private var accentPalette
    /// The active toast config from the environment. Set via `.catToastMsgConfig(variant:)`.
    @Environment(\.catToastMsgConfig) private var toastConfig

    /// Creates a `CatToastMsg` with a trailing action slot.
    ///
    /// - Parameters:
    ///   - title: The toast's message text.
    ///   - icon: Optional leading status icon. Pass `nil` to hide.
    ///   - accessibilityIdentifier: An identifier used by UI automation tests to locate this toast.
    ///   - showDismissButton: When `true` (default), the internal dismiss × button is shown.
    ///   - onDismiss: Closure invoked when the dismiss button is tapped.
    ///     When `nil` and `showDismissButton == true`, the button renders but is a no-op.
    ///   - action: A view (typically a `CatButton`) shown as the action affordance.
    public init(
        _ title: String,
        icon: Image? = nil,
        accessibilityIdentifier: String? = nil,
        showDismissButton: Bool = true,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder action: () -> Action
    ) {
        self.title = title
        self.icon = icon
        self.accessibilityIdentifier = accessibilityIdentifier
        self.showDismissButton = showDismissButton
        self.onDismiss = onDismiss
        self.action = action()
    }

    public var body: some View {
        let config = CatTheme.toastMsgConfig(
            theme: theme,
            accentPalette: accentPalette
        )
        CatToastMsgBuilder(
            title: title,
            icon: icon,
            variant: toastConfig.variant,
            accessibilityIdentifier: accessibilityIdentifier,
            showDismissButton: showDismissButton,
            onDismiss: onDismiss,
            config: config
        ) {
            action
        }
    }
}

// MARK: - No-action convenience

public extension CatToastMsg where Action == EmptyView {
    /// Creates a `CatToastMsg` with no action button.
    ///
    /// - Parameters:
    ///   - title: The toast's message text.
    ///   - icon: Optional leading status icon. Pass `nil` to hide.
    ///   - accessibilityIdentifier: An identifier used by UI automation tests to locate this toast.
    ///   - showDismissButton: When `true` (default), the internal dismiss × button is shown.
    ///   - onDismiss: Closure invoked when the dismiss button is tapped.
    ///     When `nil` and `showDismissButton == true`, the button renders but is a no-op.
    init(
        _ title: String,
        icon: Image? = nil,
        accessibilityIdentifier: String? = nil,
        showDismissButton: Bool = true,
        onDismiss: (() -> Void)? = nil
    ) {
        self.init(
            title,
            icon: icon,
            accessibilityIdentifier: accessibilityIdentifier,
            showDismissButton: showDismissButton,
            onDismiss: onDismiss
        ) { EmptyView() }
    }
}

// ---------------------------------------------------------------------------
// CatToastMsgBuilder — internal layout
//
// Reads a resolved `CatToastMsgStyleConfig` and assembles either the compact
// (single-row) or expanded (stacked) layout.
// ---------------------------------------------------------------------------

struct CatToastMsgBuilder<Action: View>: View {
    let title: String
    let icon: Image?
    let variant: CatToastMsgVariant
    let accessibilityIdentifier: String?
    let showDismissButton: Bool
    let onDismiss: (() -> Void)?
    let config: CatToastMsgStyleConfig
    @ViewBuilder let action: () -> Action

    var body: some View {
        Group {
            switch variant {
            case .compact:
                compactLayout
            case .expanded:
                expandedLayout
            }
        }
        .background(config.colorStyle.background)
        .clipShape(RoundedRectangle(cornerRadius: config.cornerRadius))
        .accessibilityIdentifier(accessibilityIdentifier ?? "")
    }

    // MARK: Compact — single row, 56 pt height

    private var compactLayout: some View {
        HStack(alignment: .center, spacing: CatSpacing.spacingLg) {
            if let icon {
                iconView(icon)
            }
            Text(title)
                .font(CatTypography.s1)
                .foregroundStyle(config.colorStyle.foreground)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)

            action()
                .foregroundStyle(config.colorStyle.actionColor)
                .tint(config.colorStyle.actionColor)
                .fixedSize()

            if showDismissButton {
                dismissButton
            }
        }
        .padding(.horizontal, CatSpacing.spacingXl)
        .frame(height: 56)
    }

    // MARK: Expanded — stacked, close anchored top-right

    private var expandedLayout: some View {
        HStack(alignment: .top, spacing: CatSpacing.spacingLg) {
            if let icon {
                iconView(icon)
            }
            VStack(alignment: .leading, spacing: CatSpacing.spacingMd) {
                Text(title)
                    .font(CatTypography.s1)
                    .foregroundStyle(config.colorStyle.foreground)
                    .fixedSize(horizontal: false, vertical: true)

                action()
                    .foregroundStyle(config.colorStyle.actionColor)
                    .tint(config.colorStyle.actionColor)
                    .fixedSize()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            if showDismissButton {
                dismissButton
            }
        }
        .padding(.horizontal, CatSpacing.spacingXl)
        .padding(.vertical, CatSpacing.spacingXl)
    }

    // MARK: Shared sub-views

    private func iconView(_ icon: Image) -> some View {
        icon
            .renderingMode(.template)
            .foregroundStyle(config.colorStyle.foreground)
    }

    private var dismissButton: some View {
        Button {
            onDismiss?()
        } label: {
            Image("ic_cross-outlined-24", bundle: .catalyst)
                .renderingMode(.template)
                .foregroundStyle(config.colorStyle.foreground)
        }
        .buttonStyle(.plain)
        .accessibilityIdentifier("toast.msg.cross.dismissbutton")
    }
}

// MARK: - Environment Config

public struct CatToastMsgConfig {
    public let variant: CatToastMsgVariant

    public init(variant: CatToastMsgVariant = .compact) {
        self.variant = variant
    }
}

private struct CatToastMsgConfigKey: EnvironmentKey {
    static let defaultValue = CatToastMsgConfig()
}

extension EnvironmentValues {
    var catToastMsgConfig: CatToastMsgConfig {
        get { self[CatToastMsgConfigKey.self] }
        set { self[CatToastMsgConfigKey.self] = newValue }
    }
}

public extension View {
    func catToastMsgConfig(variant: CatToastMsgVariant = .compact) -> some View {
        environment(\.catToastMsgConfig, CatToastMsgConfig(variant: variant))
    }
}

// MARK: - Preview

#Preview("Compact — icon + action") {
    VStack(spacing: CatSpacing.spacingXl) {
        CatToastMsg(
            "File successfully saved",
            icon: Image(systemName: "checkmark.circle"),
            onDismiss: { print("dismissed") }
        ) {
            Button("Undo") { print("undo") }
        }

        CatToastMsg(
            "No internet connection available",
            showDismissButton: false
        )
    }
    .padding()
    .background(Color.gray.opacity(0.2))
}

#Preview("Expanded — icon + action") {
    CatToastMsg(
        "Your file has been successfully saved to the cloud and is now available on all your devices.",
        icon: Image(systemName: "icloud.and.arrow.up"),
        onDismiss: { print("dismissed") }
    ) {
        Button("View file") { print("view") }
    }
    .catToastMsgConfig(variant: .expanded)
    .padding()
    .background(Color.gray.opacity(0.2))
}
