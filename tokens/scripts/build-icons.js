// Format transformations

const fs = require('fs');
const path = require('path');
const svg2vectordrawable = require('svg2vectordrawable');

const iconDir = path.resolve(__dirname, '../src/icons');
const androidDir = path.resolve(__dirname, '../../android/catalyst/src/main/res/drawable');
const iosDir = path.resolve(__dirname, '../../iOS/Catalyst/Sources/Catalyst/Resources/DSAssets.xcassets');

async function main() {
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

    const errors = [];

    for (const file of fs.readdirSync(iconDir)) {
        if (path.extname(file) === '.svg') {
            const svgCode = fs.readFileSync(path.join(iconDir, file), 'utf-8');
            const iconName = path.basename(file, '.svg');

            const androidIconName = iconName
                .replace(/-/g, '_')  // Replace all hyphens with underscores
                .toLowerCase();      // Convert to lowercase

            // svg2vectordrawable cannot convert SVGs that contain embedded raster images
            // (<image> elements, including base64-encoded ones). Detect this upfront and
            // emit a clear error instead of letting the library crash with a cryptic TypeError.
            if (/<image[\s>]/i.test(svgCode)) {
                errors.push(`❌ ${file}: contains an embedded <image> element. Android Vector Drawables do not support raster images. Re-export the icon as a pure vector SVG.`);
            } else {
                try {
                    const xml = await svg2vectordrawable(svgCode);
                    const androidPath = path.join(androidDir, `${androidIconName}.xml`);
                    fs.writeFileSync(androidPath, xml);
                    console.log(`✅ Generated ${androidPath}`);
                } catch (err) {
                    errors.push(`❌ ${file}: failed to convert to Vector Drawable — ${err.message}`);
                }
            }
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
        };
        fs.writeFileSync(
            path.join(iosIconDir, 'Contents.json'),
            JSON.stringify(contentsJson, null, 2)
        );
        console.log(`✅ Generated ${iosIconDir}`);
    }

    if (errors.length > 0) {
        console.error(`\n⚠️  Build failed with ${errors.length} error(s):\n`);
        errors.forEach(e => console.error(e));
        process.exit(1);
    }
}

main();
