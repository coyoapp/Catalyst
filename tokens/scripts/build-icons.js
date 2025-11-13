// Format transformations

const fs = require('fs');
const path = require('path');
const svg2vectordrawable = require('svg2vectordrawable');

const iconDir = path.resolve(__dirname, '../src/icons');
const androidDir = path.resolve(__dirname, '../../android/designsystem/src/main/res/drawable');
const iosDir = path.resolve(__dirname, '../../iOS/DesignSystem/Sources/DesignSystemKit/Resources/DSAssets.xcassets');

if (!fs.existsSync(androidDir)) {
    fs.mkdirSync(androidDir, { recursive: true });
}

fs.readdirSync(iconDir).forEach(file => {
    if (path.extname(file) === '.svg') {
        const svgCode = fs.readFileSync(path.join(iconDir, file), 'utf-8');
        const iconName = path.basename(file, '.svg');

        const androidIconName = iconName
            .replace(/-/g, '_')  // Replace all hyphens with underscores
            .toLowerCase();      // Convert to lowercase

        // Convert and write the Android XML
        svg2vectordrawable(svgCode).then(xml => {
            const androidPath = path.join(androidDir, `${androidIconName}.xml`);
            fs.writeFileSync(androidPath, xml);
            console.log(`✅ Generated ${androidPath}`);
        });
    }

    const iconName = path.basename(file, '.svg');
    const iosIconDir = path.join(iosDir, `${iconName}.imageset`);

    if (!fs.existsSync(iosIconDir)) {
        fs.mkdirSync(iosIconDir, { recursive: true });
    }

    // 1. Copy the SVG file
    fs.copyFileSync(
        path.join(iconDir, file),
        path.join(iosIconDir, file)
    );

    // 2. Create the Contents.json file
    const contentsJson = {
        images: [{
            filename: file,
            idiom: 'universal'
        }],
        info: { version: 1, author: 'xcode' },
        properties: { 'preserves-vector-representation': true }
    }
    fs.writeFileSync(
        path.join(iosIconDir, 'Contents.json'),
        JSON.stringify(contentsJson, null, 2)
    );
    console.log(`✅ Generated ${iosIconDir}`);
});