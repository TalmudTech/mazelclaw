// swift-tools-version: 6.2
// Package manifest for the MazelClaw macOS companion (menu bar app + IPC library).

import PackageDescription

let package = Package(
    name: "MazelClaw",
    platforms: [
        .macOS(.v15),
    ],
    products: [
        .library(name: "MazelClawIPC", targets: ["MazelClawIPC"]),
        .library(name: "MazelClawDiscovery", targets: ["MazelClawDiscovery"]),
        .executable(name: "MazelClaw", targets: ["MazelClaw"]),
        .executable(name: "mazelclaw-mac", targets: ["MazelClawMacCLI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/orchetect/MenuBarExtraAccess", exact: "1.2.2"),
        .package(url: "https://github.com/swiftlang/swift-subprocess.git", from: "0.1.0"),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.8.0"),
        .package(url: "https://github.com/sparkle-project/Sparkle", from: "2.8.1"),
        .package(url: "https://github.com/steipete/Peekaboo.git", branch: "main"),
        .package(path: "../shared/MazelClawKit"),
        .package(path: "../../Swabble"),
    ],
    targets: [
        .target(
            name: "MazelClawIPC",
            dependencies: [],
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]),
        .target(
            name: "MazelClawDiscovery",
            dependencies: [
                .product(name: "MazelClawKit", package: "MazelClawKit"),
            ],
            path: "Sources/MazelClawDiscovery",
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]),
        .executableTarget(
            name: "MazelClaw",
            dependencies: [
                "MazelClawIPC",
                "MazelClawDiscovery",
                .product(name: "MazelClawKit", package: "MazelClawKit"),
                .product(name: "MazelClawChatUI", package: "MazelClawKit"),
                .product(name: "MazelClawProtocol", package: "MazelClawKit"),
                .product(name: "SwabbleKit", package: "swabble"),
                .product(name: "MenuBarExtraAccess", package: "MenuBarExtraAccess"),
                .product(name: "Subprocess", package: "swift-subprocess"),
                .product(name: "Logging", package: "swift-log"),
                .product(name: "Sparkle", package: "Sparkle"),
                .product(name: "PeekabooBridge", package: "Peekaboo"),
                .product(name: "PeekabooAutomationKit", package: "Peekaboo"),
            ],
            exclude: [
                "Resources/Info.plist",
            ],
            resources: [
                .copy("Resources/MazelClaw.icns"),
                .copy("Resources/DeviceModels"),
            ],
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]),
        .executableTarget(
            name: "MazelClawMacCLI",
            dependencies: [
                "MazelClawDiscovery",
                .product(name: "MazelClawKit", package: "MazelClawKit"),
                .product(name: "MazelClawProtocol", package: "MazelClawKit"),
            ],
            path: "Sources/MazelClawMacCLI",
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]),
        .testTarget(
            name: "MazelClawIPCTests",
            dependencies: [
                "MazelClawIPC",
                "MazelClaw",
                "MazelClawDiscovery",
                .product(name: "MazelClawProtocol", package: "MazelClawKit"),
                .product(name: "SwabbleKit", package: "swabble"),
            ],
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
                .enableExperimentalFeature("SwiftTesting"),
            ]),
    ])
