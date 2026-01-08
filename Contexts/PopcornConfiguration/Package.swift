// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PopcornConfiguration",

    defaultLocalization: "en",

    platforms: [
        .iOS(.v26),
        .macOS(.v26),
        .visionOS(.v2)
    ],

    products: [
        .library(name: "ConfigurationComposition", targets: ["ConfigurationComposition"]),
        .library(name: "ConfigurationApplication", targets: ["ConfigurationApplication"]),
        .library(name: "ConfigurationDomain", targets: ["ConfigurationDomain"]),
        .library(name: "ConfigurationInfrastructure", targets: ["ConfigurationInfrastructure"]),
        .library(name: "ConfigurationUITesting", targets: ["ConfigurationUITesting"])
    ],

    dependencies: [
        .package(path: "../../Core/CoreDomain"),
        .package(path: "../../Platform/Caching"),
        .package(path: "../../Platform/Observability")
    ],

    targets: [
        .target(
            name: "ConfigurationComposition",
            dependencies: [
                "ConfigurationApplication",
                "ConfigurationDomain",
                "ConfigurationInfrastructure"
            ]
        ),

        .target(
            name: "ConfigurationApplication",
            dependencies: [
                "ConfigurationDomain",
                "CoreDomain",
                "Observability"
            ]
        ),
        .testTarget(
            name: "ConfigurationApplicationTests",
            dependencies: [
                "ConfigurationApplication",
                .product(name: "CoreDomainTestHelpers", package: "CoreDomain"),
                .product(name: "ObservabilityTestHelpers", package: "Observability")
            ]
        ),

        .target(
            name: "ConfigurationDomain",
            dependencies: [
                "CoreDomain"
            ]
        ),
        .testTarget(
            name: "ConfigurationDomainTests",
            dependencies: [
                "ConfigurationDomain"
            ]
        ),

        .target(
            name: "ConfigurationInfrastructure",
            dependencies: [
                "ConfigurationDomain",
                "Caching",
                "Observability"
            ]
        ),
        .testTarget(
            name: "ConfigurationInfrastructureTests",
            dependencies: [
                "ConfigurationInfrastructure",
                .product(name: "CachingTestHelpers", package: "Caching"),
                .product(name: "CoreDomainTestHelpers", package: "CoreDomain"),
                .product(name: "ObservabilityTestHelpers", package: "Observability")
            ]
        ),

        .target(
            name: "ConfigurationUITesting",
            dependencies: [
                "ConfigurationComposition",
                "ConfigurationApplication",
                "ConfigurationDomain"
            ]
        )
    ]
)
