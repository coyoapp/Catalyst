package com.haiilo.catalyst.components.alerts

// ---------------------------------------------------------------------------
// CatAlertColor — semantic color role for the alert
// ---------------------------------------------------------------------------

enum class CatAlertColor {
    /** Default action — teal. */
    Primary,

    /** Informational — blue. */
    Info,

    /** Confirmation — green. */
    Success,

    /** Warning — amber. */
    Warning,

    /** Destructive — red. */
    Danger,

    /** Neutral — no semantic color, uses UI border/font tokens. */
    Default,
}

// ---------------------------------------------------------------------------
// CatAlertButtonPlacement — where the action button is positioned
// ---------------------------------------------------------------------------

enum class CatAlertButtonPlacement {
    /**
     * Chooses the best layout automatically.
     *
     * Short headings with an action stay inline; longer headings fall back to a
     * stacked layout with the action below the text.
     */
    Automatic,

    /**
     * Button sits on the trailing edge in the same row as the heading.
     * Best for short, single-line headings.
     */
    Trailing,

    /**
     * Button sits below the heading text, start-aligned.
     * Best for longer headings that wrap to multiple lines.
     */
    Below,
}
