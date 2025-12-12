// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

/// This package manifest serves as the root entry point for the Swift Package Manager.
///
/// This file explicitly points to the Design System's source code,
/// which is located in the `/iOS/Catalyst` subdirectory, making it discoverable as a remote package.

import PackageDescription

let package = Package(
    name: "Catalyst",
    platforms: [
        .iOS(.v16) // or whatever minimum you support
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Catalyst",
            targets: ["Catalyst"]
        )
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Catalyst",
            path: "iOS/Catalyst/Sources/Catalyst"
        )
    ]
)
