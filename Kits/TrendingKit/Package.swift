// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TrendingKit",

    defaultLocalization: "en",

    platforms: [
        .iOS(.v26),
        .macOS(.v26),
        .visionOS(.v2)
    ],

    products: [
        .library(name: "TrendingApplication", targets: ["TrendingApplication"]),
        .library(name: "TrendingDomain", targets: ["TrendingDomain"]),
        .library(name: "TrendingInfrastructure", targets: ["TrendingInfrastructure"])
    ],

    dependencies: [
        .package(path: "../../Core/CoreDomain")
    ],

    targets: [
        .target(
            name: "TrendingApplication",
            dependencies: [
                "TrendingDomain",
                "TrendingInfrastructure",
                "CoreDomain"
            ]
        ),
        .testTarget(
            name: "TrendingApplicationTests",
            dependencies: ["TrendingApplication"]
        ),

        .target(
            name: "TrendingDomain",
            dependencies: [
                "CoreDomain"
            ]
        ),
        .testTarget(
            name: "TrendingDomainTests",
            dependencies: ["TrendingDomain"]
        ),

        .target(
            name: "TrendingInfrastructure",
            dependencies: [
                "TrendingDomain"
            ]
        ),
        .testTarget(
            name: "TrendingInfrastructureTests",
            dependencies: ["TrendingInfrastructure"]
        )
    ]
)
