// swift-tools-version:5.6

import PackageDescription
import Foundation

let package = Package(
    name: "KipplePlugins",
    products: [
        .plugin(name: "KipplePlugins", targets: [
            "Format",
//            "Lint",
        ]),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-kipple/PluginSupport", from: "0.1.1"),
        .package(url: "https://github.com/nicklockwood/SwiftFormat", from: "0.49.13"),
//        .package(url: "https://github.com/Realm/SwiftLint", from: "0.47.1"),
    ],
    targets: [
        // Plugins
        .plugin(
            name: "Format",
            capability: .command(
                intent: .custom(verb: "format", description: "Format swift files."),
                permissions: [
                    .writeToPackageDirectory(reason: "Format Swift files using SwiftFormat."),
                ]
            ),
            dependencies: [
                .product(name: "swiftformat", package: "SwiftFormat"),
                .product(name: "kipple-file-provider", package: "PluginSupport"),
            ]
        ),
//        .plugin(
//            name: "Lint",
//            capability: .command(
//                intent: .custom(verb: "lint", description: "Lint swift files."),
//                permissions: [
//                    .writeToPackageDirectory(reason: "Lint Swift files using SwiftLint."),
//                ]
//            ),
//            dependencies: [
//                .product(name: "swiftlint", package: "SwiftLint"),
//            ]
//        ),
    ]
)
