// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FeatureAccessAdapters",

    defaultLocalization: "en",

    platforms: [
        .iOS(.v26),
        .macOS(.v26),
        .visionOS(.v2)
    ],

    products: [
        .library(name: "FeatureAccessAdapters", targets: ["FeatureAccessAdapters"])
    ],

    dependencies: [
        .package(path: "../../../Platform/FeatureAccess"),
        .package(url: "https://github.com/statsig-io/statsig-kit.git", from: "1.55.1")
    ],

    targets: [
        .target(
            name: "FeatureAccessAdapters",
            dependencies: [
                "FeatureAccess",
                .product(name: "Statsig", package: "statsig-kit")
            ]
        ),
        .testTarget(
            name: "FeatureAccessAdaptersTests",
            dependencies: ["FeatureAccessAdapters"]
        )
    ]
)
