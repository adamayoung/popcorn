// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PersonDetailsFeature",

    defaultLocalization: "en",

    platforms: [
        .iOS(.v26),
        .macOS(.v26),
        .visionOS(.v26)
    ],

    products: [
        .library(name: "PersonDetailsFeature", targets: ["PersonDetailsFeature"])
    ],

    dependencies: [
        .package(path: "../../Core/CoreDomain"),
        .package(path: "../../Core/DesignSystem"),
        .package(path: "../../Core/Presentation"),
        .package(path: "../../Contexts/PopcornPeople"),
        .package(path: "../../Core/SnapshotTestHelpers")
    ],

    targets: [
        .target(
            name: "PersonDetailsFeature",
            dependencies: [
                "DesignSystem",
                "Presentation",
                .product(name: "PeopleApplication", package: "PopcornPeople")
            ],
            resources: [.process("Localizable.xcstrings")]
        ),
        .testTarget(
            name: "PersonDetailsFeatureTests",
            dependencies: [
                "PersonDetailsFeature",
                .product(name: "CoreDomain", package: "CoreDomain"),
                .product(name: "PeopleApplication", package: "PopcornPeople")
            ]
        ),
        .testTarget(
            name: "PersonDetailsFeatureSnapshotTests",
            dependencies: [
                "PersonDetailsFeature",
                "SnapshotTestHelpers"
            ]
        )
    ]
)
