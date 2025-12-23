// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PopcornChat",

    defaultLocalization: "en",

    platforms: [
        .iOS(.v26),
        .macOS(.v26),
        .visionOS(.v2)
    ],

    products: [
        .library(name: "ChatComposition", targets: ["ChatComposition"]),
        .library(name: "ChatApplication", targets: ["ChatApplication"]),
        .library(name: "ChatDomain", targets: ["ChatDomain"]),
        .library(name: "ChatInfrastructure", targets: ["ChatInfrastructure"])
    ],

    dependencies: [
        .package(path: "../../Core/CoreDomain"),
        .package(path: "../../Platform/Observability")
    ],

    targets: [
        .target(
            name: "ChatComposition",
            dependencies: [
                "ChatApplication",
                "ChatDomain",
                "ChatInfrastructure"
            ]
        ),

        .target(
            name: "ChatApplication",
            dependencies: [
                "ChatDomain",
                "CoreDomain"
            ]
        ),
        .testTarget(
            name: "ChatApplicationTests",
            dependencies: ["ChatApplication"]
        ),

        .target(
            name: "ChatDomain",
            dependencies: [
                "CoreDomain"
            ]
        ),
        .testTarget(
            name: "ChatDomainTests",
            dependencies: [
                "ChatDomain"
            ]
        ),

        .target(
            name: "ChatInfrastructure",
            dependencies: [
                "ChatDomain",
                "Observability"
            ]
        ),
        .testTarget(
            name: "ChatInfrastructureTests",
            dependencies: [
                "ChatInfrastructure",
                "ChatDomain",
                .product(name: "ObservabilityTestHelpers", package: "Observability")
            ]
        )
    ]
)
