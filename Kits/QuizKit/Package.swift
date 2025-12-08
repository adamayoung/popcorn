// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "QuizKit",
    defaultLocalization: "en",

    platforms: [
        .iOS(.v26),
        .macOS(.v26),
        .visionOS(.v2)
    ],

    products: [
        .library(name: "QuizApplication", targets: ["QuizApplication"]),
        .library(name: "QuizDomain", targets: ["QuizDomain"]),
        .library(name: "QuizInfrastructure", targets: ["QuizInfrastructure"])
    ],

    dependencies: [
        .package(path: "../../Core/CoreDomain")
    ],

    targets: [
        .target(
            name: "QuizApplication",
            dependencies: [
                "QuizDomain",
                "QuizInfrastructure",
                "CoreDomain"
            ]
        ),
        .testTarget(
            name: "QuizApplicationTests",
            dependencies: ["QuizApplication"]
        ),

        .target(
            name: "QuizDomain",
            dependencies: [
                "CoreDomain"
            ]
        ),
        .testTarget(
            name: "QuizDomainTests",
            dependencies: ["QuizDomain"]
        ),

        .target(
            name: "QuizInfrastructure",
            dependencies: [
                "QuizDomain"
            ]
        ),
        .testTarget(
            name: "QuizInfrastructureTests",
            dependencies: [
                "QuizInfrastructure",
                "QuizDomain"
            ]
        )
    ]
)
