// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MediaSearchFeature",

    defaultLocalization: "en",

    platforms: [
        .iOS(.v26),
        .macOS(.v26),
        .visionOS(.v2)
    ],

    products: [
        .library(name: "MediaSearchFeature", targets: ["MediaSearchFeature"])
    ],

    dependencies: [
        .package(path: "../../AppDependencies"),
        .package(path: "../../Core/CoreDomain"),
        .package(path: "../../Core/DesignSystem"),
        .package(path: "../../Contexts/PopcornSearch"),
        .package(
            url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "1.23.1"
        )
    ],

    targets: [
        .target(
            name: "MediaSearchFeature",
            dependencies: [
                "AppDependencies",
                "DesignSystem",
                .product(name: "SearchApplication", package: "PopcornSearch"),
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ],
            resources: [.process("Localizable.xcstrings")]
        ),
        .testTarget(
            name: "MediaSearchFeatureTests",
            dependencies: [
                "MediaSearchFeature",
                .product(name: "CoreDomain", package: "CoreDomain"),
                .product(name: "SearchApplication", package: "PopcornSearch")
            ]
        )
    ]
)
