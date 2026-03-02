// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AnalyticsAdapters",

    defaultLocalization: "en",

    platforms: [
        .iOS(.v26),
        .macOS(.v26),
        .visionOS(.v2)
    ],

    products: [
        .library(name: "AnalyticsAdapters", targets: ["AnalyticsAdapters"])
    ],

    dependencies: [
        .package(path: "../../../Platform/Analytics"),
        .package(url: "https://github.com/amplitude/Amplitude-Swift.git", from: "1.17.3")
    ],

    targets: [
        .target(
            name: "AnalyticsAdapters",
            dependencies: [
                "Analytics",
                .product(name: "AmplitudeSwift", package: "Amplitude-Swift")
            ]
        ),
        .testTarget(
            name: "AnalyticsAdaptersTests",
            dependencies: [
                "AnalyticsAdapters",
                "Analytics"
            ]
        )
    ]
)
