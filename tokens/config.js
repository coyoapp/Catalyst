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

// Style Dictionary will perform all the standard iOS transformations except for the ones
// that interfere with our custom typography formatter:
//   - 'color/UIColor'     removed: had formatting issues with our color output
//   - 'font/swift/literal' removed: wraps font token values in double-quotes via template
//                                   literal which coerces compound objects to "[object Object]";
//                                   our custom formatter handles font name construction itself
StyleDictionary.registerTransformGroup({
    name: 'ios-swift-custom',
    transforms: [
        'attribute/cti',
        'name/cti/camel',
        // 'color/UIColor' removed from this list
        'content/swift/literal',
        'asset/swift/literal',
        'size/swift/remToCGFloat',
        // 'font/swift/literal' removed — see comment above
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

// Formatter for SwiftUI Typography
StyleDictionary.registerFormat({
    name: 'swift/swiftui-typography',
    formatter: function ({ dictionary }) {
        let swiftFile = `//\n// CatTypography.swift\n//\n// Do not edit directly, this file is generated from design tokens\n//\n\nimport SwiftUI\nimport UIKit\n\npublic enum CatTypography {\n`;

        // Maps "fontWeight-fontStyle" to the Lato font file suffix.
        // fontWeight and fontStyle are separate scalar tokens resolved from font-properties.json.
        const weightStyleToFontSuffix = {
            "700-normal": "Bold",
            "600-normal": "Semibold",
            "500-normal": "Medium",
            "400-normal": "Regular",
            "300-normal": "Light",
            "400-italic": "Italic",
            "500-italic": "MediumItalic",
            "600-italic": "SemiboldItalic",
            "700-italic": "BoldItalic",
            "300-italic": "LightItalic"
        };

        const entries = [];
        dictionary.allProperties.forEach(prop => {
            const val = prop.value;
            // fontWeight resolves to a plain numeric string ("700", "400", etc.)
            // fontStyle resolves to a plain string ("normal" or "italic")
            const weight = val.fontWeight;
            const style = val.fontStyle || 'normal';
            const size = parseFloat(val.fontSize);
            const fontSuffix = weightStyleToFontSuffix[`${weight}-${style}`] || "Regular";
            const fontFamily = val.fontFamily;
            // Construct the proper font name, e.g., "Lato-Bold", "Lato-Italic", "Lato-BoldItalic"
            const fontName = `${fontFamily}-${fontSuffix}`;
            const propName = prop.path.slice(-1)[0];

            entries.push({ propName, fontName, size });
            swiftFile += `    public static let ${propName} = Font.custom("${fontName}", size: ${size.toFixed(2)})\n`;
        });

        swiftFile += `}\n`;

        swiftFile += `\npublic enum CatTypographyUIFont {\n`;
        swiftFile += `    private static func font(_ name: String, size: CGFloat) -> UIFont {\n`;
        swiftFile += `        UIFont(name: name, size: size) ?? .systemFont(ofSize: size)\n`;
        swiftFile += `    }\n\n`;
        entries.forEach(({ propName, fontName, size }) => {
            swiftFile += `    public static let ${propName} = font("${fontName}", size: ${size})\n`;
        });
        swiftFile += `}\n`;

        return swiftFile;
    }
});


// Formatter for Android XML Typography (res/values/cat_typography.xml)
StyleDictionary.registerFormat({
    name: 'xml/android-typography',
    formatter: function ({ dictionary }) {
        // Maps "fontWeight-fontStyle" to the Android @font resource suffix.
        // fontWeight and fontStyle are separate scalar tokens resolved from font-properties.json.
        const weightStyleToFontSuffix = {
            "700-normal": "bold",
            "600-normal": "semibold",
            "500-normal": "medium",
            "400-normal": "regular",
            "300-normal": "light",
            "400-italic": "italic",
            "500-italic": "medium_italic",
            "600-italic": "semibold_italic",
            "700-italic": "bold_italic",
            "300-italic": "light_italic"
        };

        function toPascalCase(str) {
            return str.charAt(0).toUpperCase() + str.slice(1);
        }

        let xml = `<?xml version="1.0" encoding="utf-8"?>\n`;
        xml += `<!--\n  Do not edit directly, this file is generated from design tokens\n-->\n`;
        xml += `<resources>\n`;

        // Base style required by Android for dot-notation inheritance (e.g. CatTypography.H1)
        xml += `\n    <style name="CatTypography" />\n`;

        dictionary.allProperties.forEach(prop => {
            const val = prop.value;
            const propName = prop.path.slice(-1)[0];
            const styleName = `CatTypography.${toPascalCase(propName)}`;
            const fontSize = parseFloat(val.fontSize);
            const lineHeight = parseFloat(val.lineHeight);
            // fontWeight resolves to a plain numeric string ("700", "400", etc.)
            // fontStyle resolves to a plain string ("normal" or "italic")
            const fontWeight = val.fontWeight;
            const fontStyle = val.fontStyle || 'normal';
            const fontFamily = val.fontFamily.toLowerCase();

            const suffix = weightStyleToFontSuffix[`${fontWeight}-${fontStyle}`] || "regular";
            // "regular" maps to the base @font/lato resource; all others append the suffix
            const fontRef = suffix === "regular"
                ? `@font/${fontFamily}`
                : `@font/${fontFamily}_${suffix}`;

            xml += `\n    <style name="${styleName}">\n`;
            xml += `        <item name="android:fontFamily">${fontRef}</item>\n`;
            xml += `        <item name="android:textFontWeight">${fontWeight}</item>\n`;
            xml += `        <item name="android:textStyle">${fontStyle}</item>\n`;
            xml += `        <item name="android:textSize">${fontSize}sp</item>\n`;
            xml += `        <item name="android:lineHeight">${lineHeight}sp</item>\n`;
            xml += `    </style>\n`;
        });

        xml += `\n</resources>\n`;
        return xml;
    }
});

// Formatter for Android XML Dimensions (res/values/cat_*.xml)
StyleDictionary.registerFormat({
    name: 'xml/android-dimensions',
    formatter: function ({ dictionary, file }) {
        let xml = `<?xml version="1.0" encoding="utf-8"?>\n`;
        xml += `<!--\n  Do not edit directly, this file is generated from design tokens\n-->\n`;
        xml += `<resources>\n`;

        dictionary.allProperties.forEach(prop => {
            // Use the same name as Compose (e.g., spacing_none, border_radius_sm, size_xs)
            const name = `cat_${prop.name}`;
            xml += `    <dimen name="${name}">${prop.value}dp</dimen>\n`;
        });

        xml += `</resources>\n`;
        return xml;
    }
});

// Formatter for Android XML Colors (res/values/cat_colors.xml)
StyleDictionary.registerFormat({
    name: 'xml/android-colors',
    formatter: function ({ dictionary }) {
        let xml = `<?xml version="1.0" encoding="utf-8"?>\n`;
        xml += `<!--\n  Do not edit directly, this file is generated from design tokens\n-->\n`;
        xml += `<resources>\n`;

        dictionary.allProperties.forEach(prop => {
            // Build flat name from path: color.theme.danger.bg -> cat_color_theme_danger_bg
            const name = 'cat_' + prop.path.join('_');
            // prop.value is already transformed to #AARRGGBB or #RRGGBB by the android transform group
            xml += `    <color name="${name}">${prop.value}</color>\n`;
        });

        xml += `</resources>\n`;
        return xml;
    }
});

// Formatter for Compose Typography
StyleDictionary.registerFormat({
    name: 'kotlin/compose-typography',
    formatter: function ({ dictionary }) {
        // fontStyle is now a separate scalar token resolved from font-properties.json
        const hasItalic = dictionary.allProperties.some(
            prop => prop.value.fontStyle === 'italic'
        );

        let kotlinFile = `//\n// CatTypography.kt\n//\n// Do not edit directly, this file is generated from design tokens\n//\n\npackage com.haiilo.catalyst.tokens.generated\n\nimport androidx.compose.ui.text.TextStyle\nimport androidx.compose.ui.text.font.FontWeight\n`;
        if (hasItalic) {
            kotlinFile += `import androidx.compose.ui.text.font.FontStyle\n`;
        }
        kotlinFile += `import androidx.compose.ui.unit.sp\nimport com.haiilo.catalyst.CatFontFamily\n\npublic object CatTypography {\n`;

        dictionary.allProperties.forEach(prop => {
            const val = prop.value;
            const propName = prop.path.slice(-1)[0];
            // fontWeight resolves to a plain numeric string ("700", "400", etc.)
            // fontStyle resolves to a plain string ("normal" or "italic")
            const fontWeight = val.fontWeight;
            const fontStyle = val.fontStyle || 'normal';

            kotlinFile += `    public val ${propName} = TextStyle(\n`;
            kotlinFile += `        fontFamily = CatFontFamily.${val.fontFamily.toLowerCase()},\n`;
            kotlinFile += `        fontWeight = FontWeight(${fontWeight}),\n`;
            if (fontStyle === 'italic') {
                kotlinFile += `        fontStyle = FontStyle.Italic,\n`;
            }
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
                }]
        },
        'android-xml': {
            transformGroup: 'android',
            buildPath: '../android/catalyst/src/main/res/values/',
            files: [
                // ✅ Colors
                {
                    destination: 'cat_colors.xml',
                    format: 'xml/android-colors',
                    filter: (token) => token.path[1] === 'theme' || token.path[1] === 'ui'
                },
                // ✅ Spacing Dimensions
                {
                    destination: 'cat_spacing.xml',
                    format: 'xml/android-dimensions',
                    filter: {
                        type: 'spacing'
                    }
                },
                // ✅ Border Radius Dimensions
                {
                    destination: 'cat_border_radius.xml',
                    format: 'xml/android-dimensions',
                    filter: {
                        type: 'borderRadius'
                    }
                },
                // ✅ Border Width Dimensions
                {
                    destination: 'cat_border_width.xml',
                    format: 'xml/android-dimensions',
                    filter: {
                        type: 'borderWidth'
                    }
                },
                // ✅ Sizing Dimensions
                {
                    destination: 'cat_sizes.xml',
                    format: 'xml/android-dimensions',
                    filter: {
                        type: 'sizing'
                    }
                },
                // ✅ Typography Styles
                {
                    destination: 'cat_typography.xml',
                    format: 'xml/android-typography',
                    filter: {
                        type: 'typography'
                    }
                }
            ]
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
                }
            ]
        }
    }
};
