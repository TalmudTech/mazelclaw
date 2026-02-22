// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "MazelClawKit",
    platforms: [
        .iOS(.v18),
        .macOS(.v15),
    ],
    products: [
        .library(name: "MazelClawProtocol", targets: ["MazelClawProtocol"]),
        .library(name: "MazelClawKit", targets: ["MazelClawKit"]),
        .library(name: "MazelClawChatUI", targets: ["MazelClawChatUI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/steipete/ElevenLabsKit", exact: "0.1.0"),
        .package(url: "https://github.com/gonzalezreal/textual", exact: "0.3.1"),
    ],
    targets: [
        .target(
            name: "MazelClawProtocol",
            path: "Sources/MazelClawProtocol",
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]),
        .target(
            name: "MazelClawKit",
            dependencies: [
                "MazelClawProtocol",
                .product(name: "ElevenLabsKit", package: "ElevenLabsKit"),
            ],
            path: "Sources/MazelClawKit",
            resources: [
                .process("Resources"),
            ],
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]),
        .target(
            name: "MazelClawChatUI",
            dependencies: [
                "MazelClawKit",
                .product(
                    name: "Textual",
                    package: "textual",
                    condition: .when(platforms: [.macOS, .iOS])),
            ],
            path: "Sources/MazelClawChatUI",
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]),
        .testTarget(
            name: "MazelClawKitTests",
            dependencies: ["MazelClawKit", "MazelClawChatUI"],
            path: "Tests/MazelClawKitTests",
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
                .enableExperimentalFeature("SwiftTesting"),
            ]),
    ])
