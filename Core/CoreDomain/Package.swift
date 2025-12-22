// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CoreDomain",

    defaultLocalization: "en",

    platforms: [
        .iOS(.v26),
        .macOS(.v26),
        .visionOS(.v2)
    ],

    products: [
        .library(name: "CoreDomain", targets: ["CoreDomain"]),
        .library(name: "CoreDomainTestHelpers", targets: ["CoreDomainTestHelpers"])
    ],

    targets: [
        .target(name: "CoreDomain"),
        .testTarget(
            name: "CoreDomainTests",
            dependencies: ["CoreDomain"]
        ),

        .target(
            name: "CoreDomainTestHelpers",
            dependencies: ["CoreDomain"]
        )
    ]
)
