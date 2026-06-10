// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DeveloperFeature",

    defaultLocalization: "en",

    platforms: [
        .iOS(.v26),
        .macOS(.v26),
        .visionOS(.v26)
    ],

    products: [
        .library(name: "DeveloperFeature", targets: ["DeveloperFeature"])
    ],

    dependencies: [
        .package(path: "../../AppDependencies"),
        .package(path: "../../Core/DesignSystem"),
        .package(path: "../../Core/Presentation"),
        .package(path: "../../Platform/FeatureAccess"),
        .package(path: "../../Core/SnapshotTestHelpers")
    ],

    targets: [
        .target(
            name: "DeveloperFeature",
            dependencies: [
                "AppDependencies",
                "FeatureAccess",
                "DesignSystem",
                "Presentation"
            ],
            resources: [.process("Localizable.xcstrings")]
        ),
        .testTarget(
            name: "DeveloperFeatureTests",
            dependencies: [
                "DeveloperFeature",
                "FeatureAccess",
                "Presentation"
            ]
        ),
        .testTarget(
            name: "DeveloperFeatureSnapshotTests",
            dependencies: [
                "DeveloperFeature",
                "SnapshotTestHelpers"
            ]
        )
    ]
)
