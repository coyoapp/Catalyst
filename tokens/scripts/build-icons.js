// Format transformations

const fs = require('fs');
const path = require('path');
const svg2vectordrawable = require('svg2vectordrawable');

const iconDir = path.resolve(__dirname, '../src/icons');
const androidDir = path.resolve(__dirname, '../../android/catalyst/src/main/res/drawable');
const iosDir = path.resolve(__dirname, '../../iOS/Catalyst/Sources/Catalyst/Resources/DSAssets.xcassets');

// SetUp Cleaning Part:
if (fs.existsSync(androidDir)) {
    console.log(`🧹 Removing existing Android Icons folder`);
    fs.rmSync(androidDir, { recursive: true, force: true });
}
console.log(`🗂️ Android: Adding new empty assets folder`);
fs.mkdirSync(androidDir, { recursive: true });

if (fs.existsSync(iosDir)) {
    console.log(`🧹 Removing existing iOS Icons folder`);
    fs.rmSync(iosDir, { recursive: true, force: true });
}
console.log(`🗂️ iOS: Adding new empty assets folder`);
fs.mkdirSync(iosDir, { recursive: true });

console.log(`📂 iOS: Adding root Contents.json file for Asset Catalog`);
const iosRootContents = {
  info: { version: 1, author: "xcode" }
};
fs.writeFileSync(
  path.join(iosDir, 'Contents.json'),
  JSON.stringify(iosRootContents, null, 2)
);

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