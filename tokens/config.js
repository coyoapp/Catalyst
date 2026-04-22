const StyleDictionary = require('style-dictionary');

/**
 * Helper function to convert a hex color to an RGB object
 * to be used in the SwiftUI Color(red:green:blue:) initializer.
 */
function hexToRgb(hex) {
    const result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex);
    return result ? {
        r: parseInt(result[1], 16),
        g: parseInt(result[2], 16),
        b: parseInt(result[3], 16)
    } : null;
}

function buildColorTree(properties) {
    const root = {};
    const sortedProperties = [...properties].sort((a, b) => a.path.join('.').localeCompare(b.path.join('.')));

    sortedProperties.forEach((prop) => {
        // We want CatColors.theme.* and CatColors.ui.*, so drop "color".
        const pathSegments = prop.path.slice(1);
        let current = root;

        pathSegments.forEach((segment, index) => {
            const isLeaf = index === pathSegments.length - 1;
            if (isLeaf) {
                current[segment] = { token: prop };
                return;
            }

            if (!current[segment]) {
                current[segment] = {};
            }
            current = current[segment];
        });
    });

    return root;
}

function toSwiftColorLiteral(hex) {
    const rgb = hexToRgb(hex);
    if (!rgb) {
        return null;
    }

    const r = (rgb.r / 255).toFixed(3);
    const g = (rgb.g / 255).toFixed(3);
    const b = (rgb.b / 255).toFixed(3);
    return `Color(red: ${r}, green: ${g}, blue: ${b})`;
}

function buildSwiftColorNodes(node, indent) {
    let swift = '';
    Object.keys(node).forEach((key) => {
        const child = node[key];
        if (child.token) {
            const colorLiteral = toSwiftColorLiteral(child.token.value);
            if (colorLiteral) {
                swift += `${indent}public static let ${key} = ${colorLiteral} // ${child.token.value}\n`;
            }
            return;
        }

        swift += `${indent}public enum ${toPascalCase(key)} {\n`;
        swift += buildSwiftColorNodes(child, `${indent}    `);
        swift += `${indent}}\n`;
    });

    return swift;
}

function toPascalCase(value) {
    if (!value || typeof value !== 'string') {
        return value;
    }

    return value.charAt(0).toUpperCase() + value.slice(1);
}

function toComposeArgb(hex) {
    const normalized = hex.replace('#', '').toUpperCase();
    if (normalized.length === 6) {
        return `0xFF${normalized}`;
    }
    if (normalized.length === 8) {
        return `0x${normalized}`;
    }
    throw new Error(`Unsupported color format for Compose: ${hex}`);
}

function buildKotlinColorNodes(node, indent) {
    let kotlin = '';
    const keys = Object.keys(node);
    keys.forEach((key, index) => {
        const child = node[key];
        if (child.token) {
            const composeColor = toComposeArgb(child.token.value);
            kotlin += `${indent}public val ${key} = Color(${composeColor})\n`;
        } else {
            kotlin += `${indent}public object ${toPascalCase(key)} {\n`;
            kotlin += buildKotlinColorNodes(child, `${indent}    `);
            kotlin += `${indent}}\n`;
        }

        if (index < keys.length - 1) {
            const nextChild = node[keys[index + 1]];
            const hasObjectBoundary = !child.token || !nextChild.token;
            if (hasObjectBoundary) {
                kotlin += `\n`;
            }
        }
    });

    return kotlin;
}

// Style Dictionary will perform all the standard iOS transformations except for the one that converts the color to UIColor code.
// Because of the transfowmation of Colors had issues with their formattings
StyleDictionary.registerTransformGroup({
    name: 'ios-swift-custom',
    transforms: [
        'attribute/cti',
        'name/cti/camel',
        // 'color/UIColor' removed from this list
        'content/swift/literal',
        'asset/swift/literal',
        'size/swift/remToCGFloat',
        'font/swift/literal'
    ]
});

// Custom formatter for SwiftUI
StyleDictionary.registerFormat({
    name: 'swift/swiftui-colors',
    formatter: function ({ dictionary }) {
        let swiftFile = `//\n// CatColors.swift\n//\n// Do not edit directly, this file is generated from design tokens\n//\n\nimport SwiftUI\n\npublic enum CatColors {\n`;
        const tree = buildColorTree(dictionary.allProperties);
        swiftFile += buildSwiftColorNodes(tree, '    ');
        swiftFile += `}\n`;
        return swiftFile;
    }
});

// Custom formatter for Jetpack Compose
StyleDictionary.registerFormat({
    name: 'kotlin/compose-colors',
    formatter: function ({ dictionary }) {
        let kotlinFile = `//\n// CatColors.kt\n//\n// Do not edit directly, this file is generated from design tokens\n//\n\npackage com.haiilo.catalyst.tokens.generated\n\nimport androidx.compose.ui.graphics.Color\n\npublic object CatColors {\n`;
        const tree = buildColorTree(dictionary.allProperties);
        kotlinFile += buildKotlinColorNodes(tree, '    ');
        kotlinFile += `}\n`;
        return kotlinFile;
    }
});

StyleDictionary.registerFormat({
    name: 'swift/swiftui-dimensions',
    formatter: function ({ dictionary, file }) {
        const className = file.className;
        let swiftFile = `//\n// ${file.destination}\n//\n// Do not edit directly, this file is generated from design tokens\n//\n\nimport Foundation\nimport CoreGraphics\n\npublic enum ${className} {\n`;
        dictionary.allProperties.forEach(prop => {
            swiftFile += `    public static let ${prop.name}: CGFloat = ${prop.value}\n`;
        });
        swiftFile += `}\n`;
        return swiftFile;
    }
});

StyleDictionary.registerFormat({
    name: 'kotlin/compose-dimensions',
    formatter: function ({ dictionary, file }) {
        const className = file.className;
        let kotlinFile = `//\n// ${file.destination}\n//\n// Do not edit directly, this file is generated from design tokens\n//\n\npackage com.haiilo.catalyst.tokens.generated\n\nimport androidx.compose.ui.unit.dp\n\npublic object ${className} {\n`;
        dictionary.allProperties.forEach(prop => {
            kotlinFile += `    public val ${prop.name} = ${prop.value}.dp\n`;
        });
        kotlinFile += `}\n`;
        return kotlinFile;
    }
});

// Maps numeric CSS font weights to the suffix PostScript fonts typically use.
// Centralised so Swift / Kotlin / future platforms share the same contract,
// and so an unknown weight fails loudly at build time instead of silently
// falling back to "Regular" at runtime.
const FONT_WEIGHT_TO_STYLE = {
    "100": "Thin",
    "200": "ExtraLight",
    "300": "Light",
    "400": "Regular",
    "500": "Medium",
    "600": "Semibold",
    "700": "Bold",
    "800": "ExtraBold",
    "900": "Black"
};

function resolveFontStyle(rawWeight, tokenName) {
    const weight = String(rawWeight).replace(/"/g, '').trim();
    const style = FONT_WEIGHT_TO_STYLE[weight];
    if (!style) {
        throw new Error(
            `Unknown fontWeight "${weight}" for typography token "${tokenName}". ` +
            `Add it to FONT_WEIGHT_TO_STYLE in tokens/config.js.`
        );
    }
    return style;
}

// Formatter for SwiftUI font family constants.
//
// Emits one string constant per entry in `font-families.json`, giving
// `CatTheme.fontFamily` a single typed source of truth instead of magic
// strings scattered across the codebase. The value is the PostScript family
// name as it appears to CoreText (what `Font.custom(_:size:)` expects).
StyleDictionary.registerFormat({
    name: 'swift/swiftui-font-families',
    formatter: function ({ dictionary }) {
        let swiftFile = `//\n// CatFontFamilies.swift\n//\n// Do not edit directly, this file is generated from design tokens\n//\n\nimport Foundation\n\npublic enum CatFontFamilies {\n`;
        dictionary.allProperties.forEach(prop => {
            const name = prop.path.slice(-1)[0];
            const value = String(prop.value).replace(/"/g, '');
            swiftFile += `    public static let ${name} = "${value}"\n`;
        });
        swiftFile += `}\n`;
        return swiftFile;
    }
});

// Formatter for Kotlin font family name constants.
//
// Mirrors `swift/swiftui-font-families`. The generated constants are plain
// strings — the platform-specific `FontFamily` instances still live in the
// hand-written `CatFontFamily.kt`, because Compose `FontFamily` values require
// either an `R.font.*` resource id or a `DeviceFontFamilyName`, neither of
// which can be expressed in a JSON token.
StyleDictionary.registerFormat({
    name: 'kotlin/font-family-names',
    formatter: function ({ dictionary }) {
        let kotlinFile = `//\n// CatFontFamilyNames.kt\n//\n// Do not edit directly, this file is generated from design tokens\n//\n\npackage com.haiilo.catalyst.tokens.generated\n\npublic object CatFontFamilyNames {\n`;
        dictionary.allProperties.forEach(prop => {
            const name = prop.path.slice(-1)[0];
            const value = String(prop.value).replace(/"/g, '');
            kotlinFile += `    public const val ${name}: String = "${value}"\n`;
        });
        kotlinFile += `}\n`;
        return kotlinFile;
    }
});

// Formatter for SwiftUI Typography
//
// The generated file reads the font family from `CatTheme.fontFamily` at call
// time (e.g. `Font.custom("\(CatTheme.fontFamily)-Bold", size: 32)`), so the
// typographic voice can be swapped per theme without regenerating tokens.
// Only the style suffix ("-Bold", "-Semibold", …) and sizes are baked in.
StyleDictionary.registerFormat({
    name: 'swift/swiftui-typography',
    formatter: function ({ dictionary }) {
        let swiftFile = `//\n// CatTypography.swift\n//\n// Do not edit directly, this file is generated from design tokens\n//\n\nimport SwiftUI\nimport UIKit\n\npublic enum CatTypography {\n`;

        const entries = dictionary.allProperties.map(prop => {
            const val = prop.value;
            const propName = prop.path.slice(-1)[0];
            const style = resolveFontStyle(val.fontWeight, propName);
            const size = parseFloat(val.fontSize);
            if (Number.isNaN(size)) {
                throw new Error(`Invalid fontSize "${val.fontSize}" for typography token "${propName}".`);
            }
            return { propName, style, size };
        });

        entries.forEach(({ propName, style, size }) => {
            swiftFile += `    public static let ${propName} = Font.custom("\\(CatTheme.fontFamily)-${style}", size: ${size.toFixed(2)})\n`;
        });

        swiftFile += `}\n`;

        swiftFile += `\npublic enum CatTypographyUIFont {\n`;
        swiftFile += `    private static func font(_ name: String, size: CGFloat) -> UIFont {\n`;
        swiftFile += `        UIFont(name: name, size: size) ?? .systemFont(ofSize: size)\n`;
        swiftFile += `    }\n\n`;
        entries.forEach(({ propName, style, size }) => {
            swiftFile += `    public static let ${propName} = font("\\(CatTheme.fontFamily)-${style}", size: ${size})\n`;
        });
        swiftFile += `}\n`;

        return swiftFile;
    }
});


// Formatter for Compose Typography
//
// The generated file references `CatFontFamily.current` (a mutable
// `FontFamily` declared in the hand-written `CatFontFamily.kt`) rather than a
// specific family like `CatFontFamily.lato`, so host apps can swap fonts at
// runtime — the Android counterpart to iOS `CatTheme.fontFamily`.
StyleDictionary.registerFormat({
    name: 'kotlin/compose-typography',
    formatter: function ({ dictionary }) {
        let kotlinFile = `//\n// CatTypography.kt\n//\n// Do not edit directly, this file is generated from design tokens\n//\n\npackage com.haiilo.catalyst.tokens.generated\n\nimport androidx.compose.ui.text.TextStyle\nimport androidx.compose.ui.text.font.FontWeight\nimport androidx.compose.ui.unit.sp\nimport com.haiilo.catalyst.CatFontFamily\n\npublic object CatTypography {\n`;

        dictionary.allProperties.forEach(prop => {
            const val = prop.value;
            const propName = prop.path.slice(-1)[0];
            // Computed `get()` so a later change to `CatFontFamily.current`
            // is picked up on the next read instead of frozen at object init.
            kotlinFile += `    public val ${propName}: TextStyle get() = TextStyle(\n`;
            kotlinFile += `        fontFamily = CatFontFamily.current,\n`;
            kotlinFile += `        fontWeight = FontWeight(${val.fontWeight}),\n`;
            kotlinFile += `        fontSize = ${val.fontSize}.sp,\n`;
            kotlinFile += `        lineHeight = ${val.lineHeight}.sp\n`;
            kotlinFile += `    )\n`;
        });

        kotlinFile += `}\n`;
        return kotlinFile;
    }
});

module.exports = {
    source: [
        'src/base-dimensions.json',
        'src/color/**/*.json',
        'src/size/**/*.json',
        'src/typography/**/*.json'
    ],
    platforms: {
        swift: {
            transformGroup: 'ios-swift-custom',
            buildPath: '../iOS/Catalyst/Sources/Catalyst/Tokens/Generated/',
            files: [
                // ✅ Colors    
                {
                    destination: 'CatColors.swift',
                    format: 'swift/swiftui-colors',
                    // This filter ensures we only include the semantic UI/theme tokens,
                    // not the raw base palette colors.
                    filter: (token) => token.path[1] === 'theme' || token.path[1] === 'ui'
                },
                // ✅ Spacing Dimensions
                {
                    destination: 'CatSpacing.swift',
                    format: 'swift/swiftui-dimensions',
                    className: 'CatSpacing',
                    filter: {
                        type: 'spacing'
                    }
                },
                // ✅ Border Radius Dimensions
                {
                    destination: 'CatBorderRadius.swift',
                    format: 'swift/swiftui-dimensions',
                    className: 'CatBorderRadius',
                    filter: {
                        type: 'borderRadius'
                    }
                },
                // ✅ Border Width Dimensions
                {
                    destination: 'CatBorderWidth.swift',
                    format: 'swift/swiftui-dimensions',
                    className: 'CatBorderWidth',
                    filter: {
                        type: 'borderWidth'
                    }
                },
                // ✅ Sizing Dimensions
                {
                    destination: 'CatSizes.swift',
                    format: 'swift/swiftui-dimensions',
                    className: 'CatSizes',
                    filter: {
                        type: 'sizing'
                    }
                },
                // ✅ NEW: Typography Styles
                {
                    destination: 'CatTypography.swift',
                    format: 'swift/swiftui-typography',
                    filter: {
                        type: 'typography'
                    }
                },
                // ✅ Font family name constants
                {
                    destination: 'CatFontFamilies.swift',
                    format: 'swift/swiftui-font-families',
                    filter: {
                        type: 'fontFamily'
                    }
                }]
        },
        kotlin: {
            transformGroup: 'android',
            buildPath: '../android/catalyst/src/main/java/com/haiilo/catalyst/tokens/generated/',
            files: [
                // ✅ Colors
                {
                    destination: 'CatColors.kt',
                    format: 'kotlin/compose-colors',
                    // Same filter for Android to keep the output clean.
                    filter: (token) => token.path[1] === 'theme' || token.path[1] === 'ui'
                },
                // ✅ Spacing Dimensions
                {
                    destination: 'CatSpacing.kt',
                    format: 'kotlin/compose-dimensions',
                    className: 'CatSpacing',
                    filter: {
                        type: 'spacing'
                    }
                },
                // ✅ Border Radius Dimensions
                {
                    destination: 'CatBorderRadius.kt',
                    format: 'kotlin/compose-dimensions',
                    className: 'CatBorderRadius',
                    filter: {
                        type: 'borderRadius'
                    }
                },
                // ✅ Border Width Dimensions
                {
                    destination: 'CatBorderWidth.kt',
                    format: 'kotlin/compose-dimensions',
                    className: 'CatBorderWidth',
                    filter: {
                        type: 'borderWidth'
                    }
                },
                // ✅ Sizing Dimensions
                {
                    destination: 'CatSizes.kt',
                    format: 'kotlin/compose-dimensions',
                    className: 'CatSizes',
                    filter: {
                        type: 'sizing'
                    }
                },
                // ✅ Typography Styles
                {
                    destination: 'CatTypography.kt',
                    format: 'kotlin/compose-typography',
                    filter: {
                        type: 'typography'
                    }
                },
                // ✅ Font family name constants
                {
                    destination: 'CatFontFamilyNames.kt',
                    format: 'kotlin/font-family-names',
                    filter: {
                        type: 'fontFamily'
                    }
                }
            ]
        }
    }
};
