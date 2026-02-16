//
//  CatFontRegistrar.swift
//  Catalyst
//
//  Registers bundled font files so SwiftUI Font.custom can resolve them.
//

import CoreText
import Foundation

public enum CatFontRegistrar {
    private static var didRegister = false

    public static func registerFonts() {
        guard !didRegister else { return }

        let fontURLs = discoverFontURLs(in: Bundle.module)
        guard !fontURLs.isEmpty else { return }

        for url in fontURLs {
            CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
        }
        didRegister = true
    }

    private static func discoverFontURLs(in bundle: Bundle) -> [URL] {
        var urls: Set<URL> = []
        urls.formUnion(bundle.urls(forResourcesWithExtension: "ttf", subdirectory: nil) ?? [])
        urls.formUnion(bundle.urls(forResourcesWithExtension: "otf", subdirectory: nil) ?? [])

        if let root = bundle.resourceURL,
           let enumerator = FileManager.default.enumerator(
            at: root,
            includingPropertiesForKeys: nil,
            options: [.skipsHiddenFiles]
           ) {
            for case let fileURL as URL in enumerator {
                let ext = fileURL.pathExtension.lowercased()
                if ext == "ttf" || ext == "otf" {
                    urls.insert(fileURL)
                }
            }
        }
        return Array(urls)
    }
}
