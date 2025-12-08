// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TMDbAdapters",

    defaultLocalization: "en",

    platforms: [
        .iOS(.v26),
        .macOS(.v26),
        .visionOS(.v2)
    ],

    products: [
        .library(name: "TMDbAdapters", targets: ["TMDbAdapters"])
    ],

    dependencies: [
        .package(url: "https://github.com/adamayoung/TMDb.git", from: "13.4.0"),
        .package(
            url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "1.23.1")
    ],

    targets: [
        .target(
            name: "TMDbAdapters",
            dependencies: [
                "TMDb",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]
        )
    ]
)
