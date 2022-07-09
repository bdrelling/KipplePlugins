// swift-tools-version:5.6

import PackageDescription

let package = Package(
    name: "KipplePlugins",
    products: [
        .plugin(name: "KipplPlugins", targets: [
            "Format",
//            "Lint",
        ])
    ],
    dependencies: [
        .package(url: "https://github.com/nicklockwood/SwiftFormat", from: "0.49.11"),
//        .package(url: "https://github.com/Realm/SwiftLint", from: "0.47.1"),
    ],
    targets: [
        .plugin(
            name: "Format",
            capability: .command(
                intent: .custom(verb: "format", description: "Format swift files."),
                permissions: [
                    .writeToPackageDirectory(reason: "Format Swift files using SwiftFormat."),
                ]
            ),
            dependencies: [
                .target(name: "KipplePluginCore"),
                .product(name: "swiftformat", package: "SwiftFormat"),
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
//                .target(name: "KipplePluginCore"),
//                .product(name: "swiftlint", package: "SwiftLint"),
//            ]
//        ),
    ]
)
