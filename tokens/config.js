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

// Add this new section to your config file
StyleDictionary.registerTransformGroup({
    name: 'ios-swift-custom',
    transforms: [
        'attribute/cti',
        'name/cti/camel',
        // We removed 'color/UIColor' from this list
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
        let swiftFile = `//\n// DSColors.swift\n//\n// Do not edit directly, this file is generated from design tokens\n//\n\nimport SwiftUI\n\npublic enum DSColors {\n`;

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
        let kotlinFile = `//\n// DSColors.kt\n//\n// Do not edit directly, this file is generated from design tokens\n//\n\npackage com.engage.designsystem.tokens.generated\n\nimport androidx.compose.ui.graphics.Color\n\npublic object DSColors {\n`;

        dictionary.allProperties.forEach(prop => {
            const composeColor = `0xFF${prop.value.substring(1).toUpperCase()}`;
            kotlinFile += `    public val ${prop.name} = Color(${composeColor})\n`;
        });

        kotlinFile += `}\n`;
        return kotlinFile;
    }
});

// Add this formatter for Swift Dimensions (CGFloat)
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

// Add this formatter for Compose Dimensions (.dp)
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

module.exports = {
    // We assume your JSON files are in a "tokens" folder.
    // Style Dictionary merges them before processing.
    source: [
        'src/color/**/*.json',
        'src/size/**/*.json'
    ],
    platforms: {
        swift: {
            transformGroup: 'ios-swift-custom',
            // Define your output path for the Swift project.
            // Make sure this path exists or the build might fail.
            buildPath: '../iOS/DesignSystem/Sources/DesignSystemKit/Tokens/Generated/',
            files: [
                // ✅ Colors    
                {
                    destination: 'DSColors.swift',
                    format: 'swift/swiftui-colors',
                    // This filter ensures we only include the semantic UI/theme tokens,
                    // not the raw base palette colors.
                    filter: (token) => token.path[1] === 'theme' || token.path[1] === 'ui'
                },
                // ✅ Spacing Dimensions
                {
                    destination: 'DSSpacing.swift',
                    format: 'swift/swiftui-dimensions',
                    className: 'DSSpacing',
                    filter: {
                        type: 'spacing'
                    }
                },
                // ✅ Border Radius Dimensions
                {
                    destination: 'DSBorderRadius.swift',
                    format: 'swift/swiftui-dimensions',
                    className: 'DSBorderRadius',
                    filter: {
                        type: 'borderRadius'
                    }
                },
                // ✅ Border Width Dimensions
                {
                    destination: 'DSBorderWidth.swift',
                    format: 'swift/swiftui-dimensions',
                    className: 'DSBorderWidth',
                    filter: {
                        type: 'borderWidth'
                    }
                },
                // ✅ Sizing Dimensions
                {
                    destination: 'DSSizes.swift',
                    format: 'swift/swiftui-dimensions',
                    className: 'DSSizes',
                    filter: {
                        type: 'sizing'
                    }
                }]
        },
        kotlin: {
            transformGroup: 'android',
            // Define your output path for the Android project.
            // Make sure this path exists.
            buildPath: '../android/designsystem/src/main/java/com/engage/designsystem/tokens/generated/',
            files: [
                // ✅ Colors
                {
                    destination: 'DSColors.kt',
                    format: 'kotlin/compose-colors',
                    // Same filter for Android to keep the output clean.
                    filter: (token) => token.path[1] === 'theme' || token.path[1] === 'ui'
                },
                // ✅ Spacing Dimensions
                {
                    destination: 'DSSpacing.kt',
                    format: 'kotlin/compose-dimensions',
                    className: 'DSSpacing',
                    filter: {
                        type: 'spacing'
                    }
                },
                // ✅ Border Radius Dimensions
                {
                    destination: 'DSBorderRadius.kt',
                    format: 'kotlin/compose-dimensions',
                    className: 'DSBorderRadius',
                    filter: {
                        type: 'borderRadius'
                    }
                },
                // Border Width Dimensions
                {
                    destination: 'DSBorderWidth.kt',
                    format: 'kotlin/compose-dimensions',
                    className: 'DSBorderWidth',
                    filter: {
                        type: 'borderWidth'
                    }
                },
                // Sizing Dimensions
                {
                    destination: 'DSSizes.kt',
                    format: 'kotlin/compose-dimensions',
                    className: 'DSSizes',
                    filter: {
                        type: 'sizing'
                    }
                }]
        }
    }
};
