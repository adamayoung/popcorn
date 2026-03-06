// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ThemeColorProvider",

    defaultLocalization: "en",

    platforms: [
        .iOS(.v26),
        .macOS(.v26),
        .visionOS(.v2)
    ],

    products: [
        .library(name: "ThemeColorProvider", targets: ["ThemeColorProvider"])
    ],

    dependencies: [
        .package(path: "../../Core/CoreDomain"),
        .package(path: "../Caching")
    ],

    targets: [
        .target(
            name: "ThemeColorProvider",
            dependencies: [
                "CoreDomain",
                "Caching"
            ]
        ),
        .testTarget(
            name: "ThemeColorProviderTests",
            dependencies: [
                "ThemeColorProvider",
                .product(name: "CoreDomainTestHelpers", package: "CoreDomain"),
                .product(name: "CachingTestHelpers", package: "Caching")
            ]
        )
    ]
)
