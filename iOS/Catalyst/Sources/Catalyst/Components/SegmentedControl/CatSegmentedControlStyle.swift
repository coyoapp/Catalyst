//
//  CatSegmentedControlStyle.swift
//  Catalyst
//

import SwiftUI

// MARK: - Style config

/// Everything `CatSegmentedControlBuilder` needs to render a `CatSegmentedControl`.
/// Produced by `CatTheme.segmentedControlConfig(theme:accentPalette:)`.
///
/// `CatSegmentedControl` has **no** interaction-state matrix (normal/hovered/pressed/…):
/// a segment is either selected or unselected, and the sliding selection pill itself is the
/// tap feedback. Mirroring `CatButtonStateStyleConfig` here would be dead structure — the
/// same reasoning as `CatAlertColorStyle`.
///
/// Colors come from the theme resolver; the structural values default to design tokens so
/// callers almost never set them, but they stay overridable for forward-compatibility.
public struct CatSegmentedControlStyleConfig: Sendable {
    /// Background fill of the outer track.
    public let trackBackground: Color
    /// Background fill of the selected segment's pill.
    public let selectedBackground: Color
    /// Label color of the selected segment.
    public let selectedText: Color
    /// Label color of unselected segments.
    public let unselectedText: Color
    /// Label font of the selected segment.
    public let selectedFont: Font
    /// Label font of unselected segments.
    public let unselectedFont: Font
    /// Corner radius of the outer track.
    public let trackCornerRadius: CGFloat
    /// Corner radius of the selection pill.
    public let segmentCornerRadius: CGFloat
    /// Fixed height of each segment.
    public let segmentHeight: CGFloat
    /// Inset between the track edge and the segments.
    public let trackPadding: CGFloat

    public init(
        trackBackground: Color,
        selectedBackground: Color,
        selectedText: Color,
        unselectedText: Color,
        selectedFont: Font = CatTypography.button1,
        unselectedFont: Font = CatTypography.button2,
        trackCornerRadius: CGFloat = CatBorderRadius.borderRadiusLg,
        segmentCornerRadius: CGFloat = CatBorderRadius.borderRadiusMd,
        segmentHeight: CGFloat = CatSizes.size2xl,
        trackPadding: CGFloat = CatSpacing.spacingXs
    ) {
        self.trackBackground = trackBackground
        self.selectedBackground = selectedBackground
        self.selectedText = selectedText
        self.unselectedText = unselectedText
        self.selectedFont = selectedFont
        self.unselectedFont = unselectedFont
        self.trackCornerRadius = trackCornerRadius
        self.segmentCornerRadius = segmentCornerRadius
        self.segmentHeight = segmentHeight
        self.trackPadding = trackPadding
    }
}
