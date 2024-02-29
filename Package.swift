// swift-tools-version: 5.7

import PackageDescription
import Foundation

let package = Package(
    name: "KipplePlugins",
    platforms: [
        .macOS(.v13),
    ],
    products: [
        .plugin(name: "KipplePlugins", targets: [
            "Format",
        ]),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-kipple/Tools", from: "0.4.0"),
    ],
    targets: [
        // Plugins
        .plugin(
            name: "Format",
            capability: .command(
                intent: .custom(verb: "format", description: "Format swift files."),
                permissions: [
                    .writeToPackageDirectory(reason: "Format Swift files."),
                ]
            ),
            dependencies: [
                .product(name: "kipple", package: "Tools"),
            ]
        ),
    ]
)
