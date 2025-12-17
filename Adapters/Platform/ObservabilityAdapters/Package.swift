// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ObservabilityAdapters",

    defaultLocalization: "en",

    platforms: [
        .iOS(.v26),
        .macOS(.v26),
        .visionOS(.v2)
    ],

    products: [
        .library(name: "ObservabilityAdapters", targets: ["ObservabilityAdapters"])
    ],

    dependencies: [
        .package(path: "../../../Platform/Observability"),
        .package(url: "https://github.com/getsentry/sentry-cocoa.git", from: "8.40.1")
    ],
    
    targets: [
        .target(
            name: "ObservabilityAdapters",
            dependencies: [
                "Observability",
                .product(name: "Sentry", package: "sentry-cocoa")
            ]
        )
    ]
)
