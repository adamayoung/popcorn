// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PopcornIntelligence",

    defaultLocalization: "en",

    platforms: [
        .iOS(.v26),
        .macOS(.v26),
        .visionOS(.v2)
    ],

    products: [
        .library(name: "IntelligenceComposition", targets: ["IntelligenceComposition"]),
        .library(name: "IntelligenceApplication", targets: ["IntelligenceApplication"]),
        .library(name: "IntelligenceDomain", targets: ["IntelligenceDomain"]),
        .library(name: "IntelligenceInfrastructure", targets: ["IntelligenceInfrastructure"])
    ],

    dependencies: [
        .package(path: "../../Core/CoreDomain"),
        .package(path: "../../Platform/Observability")
    ],

    targets: [
        .target(
            name: "IntelligenceComposition",
            dependencies: [
                "IntelligenceApplication",
                "IntelligenceDomain",
                "IntelligenceInfrastructure"
            ]
        ),

        .target(
            name: "IntelligenceApplication",
            dependencies: [
                "IntelligenceDomain",
                "CoreDomain"
            ]
        ),
        .testTarget(
            name: "IntelligenceApplicationTests",
            dependencies: [
                "IntelligenceApplication",
                "IntelligenceDomain"
            ]
        ),

        .target(
            name: "IntelligenceDomain",
            dependencies: [
                "CoreDomain"
            ]
        ),
        .testTarget(
            name: "IntelligenceDomainTests",
            dependencies: [
                "IntelligenceDomain"
            ]
        ),

        .target(
            name: "IntelligenceInfrastructure",
            dependencies: [
                "IntelligenceDomain",
                "Observability"
            ]
        ),
        .testTarget(
            name: "IntelligenceInfrastructureTests",
            dependencies: [
                "IntelligenceInfrastructure",
                "IntelligenceDomain",
                .product(name: "ObservabilityTestHelpers", package: "Observability")
            ]
        )
    ]
)
