// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FeatureAccess",

    defaultLocalization: "en",

    platforms: [
        .iOS(.v26),
        .macOS(.v26),
        .visionOS(.v2)
    ],

    products: [
        .library(name: "FeatureAccess", targets: ["FeatureAccess"]),
        .library(name: "FeatureAccessTestHelpers", targets: ["FeatureAccessTestHelpers"])
    ],

    dependencies: [],

    targets: [
        .target(
            name: "FeatureAccess"
        ),
        .target(
            name: "FeatureAccessTestHelpers",
            dependencies: ["FeatureAccess"]
        ),
        .testTarget(
            name: "FeatureAccessTests",
            dependencies: ["FeatureAccess"]
        )
    ]
)
