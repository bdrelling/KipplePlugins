// swift-tools-version:5.6

import PackageDescription
import Foundation

let package = Package(
    name: "KipplePlugins",
    platforms: [
        .macOS(.v10_15),
    ],
    products: [
        .plugin(name: "KipplePlugins", targets: [
            "Format",
        ]),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-kipple/Tools", from: "0.2.1"),
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
