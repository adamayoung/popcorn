// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TCAFoundation",

    platforms: [
        .iOS(.v26),
        .macOS(.v26),
        .visionOS(.v2)
    ],

    products: [
        .library(name: "TCAFoundation", targets: ["TCAFoundation"])
    ],

    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-case-paths.git", from: "1.7.0")
    ],

    targets: [
        .target(
            name: "TCAFoundation",
            dependencies: [
                .product(name: "CasePaths", package: "swift-case-paths")
            ]
        ),
        .testTarget(
            name: "TCAFoundationTests",
            dependencies: ["TCAFoundation"]
        )
    ]
)
