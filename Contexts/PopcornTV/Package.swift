// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PopcornTV",

    defaultLocalization: "en",

    platforms: [
        .iOS(.v26),
        .macOS(.v26),
        .visionOS(.v2)
    ],

    products: [
        .library(name: "TVComposition", targets: ["TVComposition"]),
        .library(name: "TVApplication", targets: ["TVApplication"]),
        .library(name: "TVDomain", targets: ["TVDomain"]),
        .library(name: "TVInfrastructure", targets: ["TVInfrastructure"])
    ],

    dependencies: [
        .package(path: "../../Core/CoreDomain"),
        .package(path: "../../Platform/Caching")
    ],

    targets: [
        .target(
            name: "TVComposition",
            dependencies: [
                "TVApplication",
                "TVDomain",
                "TVInfrastructure"
            ]
        ),

        .target(
            name: "TVApplication",
            dependencies: [
                "TVDomain",
                "CoreDomain"
            ]
        ),
        .testTarget(
            name: "TVApplicationTests",
            dependencies: ["TVApplication"]
        ),

        .target(
            name: "TVDomain",
            dependencies: [
                "CoreDomain"
            ]
        ),
        .testTarget(
            name: "TVDomainTests",
            dependencies: ["TVDomain"]
        ),

        .target(
            name: "TVInfrastructure",
            dependencies: [
                "TVDomain",
                "Caching"
            ]
        ),
        .testTarget(
            name: "TVInfrastructureTests",
            dependencies: ["TVInfrastructure"]
        )
    ]
)
