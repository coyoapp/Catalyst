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

        dictionary.allProperties.forEach(prop => {
            const rgb = hexToRgb(prop.value);
            if (rgb) {
                const r = (rgb.r / 255).toFixed(3);
                const g = (rgb.g / 255).toFixed(3);
                const b = (rgb.b / 255).toFixed(3);
                swiftFile += `    public static let ${prop.name} = Color(red: ${r}, green: ${g}, blue: ${b}) // ${prop.value}\n`;
            }
        });

        swiftFile += `}\n`;
        return swiftFile;
    }
});

// Custom formatter for Jetpack Compose
StyleDictionary.registerFormat({
    name: 'kotlin/compose-colors',
    formatter: function ({ dictionary, options }) {
        const { outputReferences } = options;
        let kotlinFile = `//\n// CatColors.kt\n//\n// Do not edit directly, this file is generated from design tokens\n//\n\npackage com.engage.designsystem.tokens.generated\n\nimport androidx.compose.ui.graphics.Color\n\npublic object CatColors {\n`;

        dictionary.allProperties.forEach(prop => {
            const composeColor = `0xFF${prop.value.substring(1).toUpperCase()}`;
            kotlinFile += `    public val ${prop.name} = Color(${composeColor})\n`;
        });

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
        let kotlinFile = `//\n// ${file.destination}\n//\n// Do not edit directly, this file is generated from design tokens\n//\n\npackage com.engage.designsystem.tokens.generated\n\nimport androidx.compose.ui.unit.dp\n\npublic object ${className} {\n`;
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
        let swiftFile = `//\n// CatTypography.swift\n//\n// Do not edit directly, this file is generated from design tokens\n//\n\nimport SwiftUI\n\npublic enum CatTypography {\n`;

        const weightToStyle = {
            "700": "Bold",
            "600": "SemiBold",
            "500": "Medium",
            "400": "Regular",
            "300": "Light"
        };

        dictionary.allProperties.forEach(prop => {
            const val = prop.value;
            // The font/weight/swift transform already converted fontWeight to .bold, .regular etc.
            const weight = val.fontWeight.replace(/"/g, '');;
            const size = parseFloat(val.fontSize);
            // Look up the style (e.g., "Bold") from the fontWeight value ("700")
            const style = weightToStyle[weight] || "Regular";
            const fontFamily = val.fontFamily.replace(/"/g, '');
            // Construct the proper font name, e.g., "Lato-Bold"
            const fontName = `${fontFamily}-${style}`;
            const propName = prop.path.slice(-1)[0];

            swiftFile += `    public static let ${propName} = Font.custom("${fontName}", size: ${size.toFixed(2)})\n`;
        });

        swiftFile += `}\n`;
        return swiftFile;
    }
});


// Formatter for Compose Typography
StyleDictionary.registerFormat({
    name: 'kotlin/compose-typography',
    formatter: function ({ dictionary }) {
        let kotlinFile = `//\n// CatTypography.kt\n//\n// Do not edit directly, this file is generated from design tokens\n//\n\npackage com.engage.designsystem.tokens.generated\n\nimport androidx.compose.ui.text.TextStyle\nimport androidx.compose.ui.text.font.FontWeight\nimport androidx.compose.ui.unit.sp\nimport com.engage.designsystem.CatFontFamily\n\npublic object CatTypography {\n`;

        dictionary.allProperties.forEach(prop => {
            const val = prop.value;
            const propName = prop.path.slice(-1)[0];
            kotlinFile += `    public val ${propName} = TextStyle(\n`;
            kotlinFile += `        fontFamily = CatFontFamily.${val.fontFamily.toLowerCase()},\n`;
            kotlinFile += `        fontWeight = FontWeight(${val.fontWeight}),\n`;
            kotlinFile += `        fontSize = ${val.fontSize}.sp,\n`;
            kotlinFile += `        lineHeight = ${val.lineHeight}.sp\n`;
            kotlinFile += `    )\n\n`;
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
        kotlin: {
            transformGroup: 'android',
            buildPath: '../android/designsystem/src/main/java/com/engage/designsystem/tokens/generated/',
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
