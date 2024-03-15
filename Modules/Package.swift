// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "GameCounter",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "AppFeature",
            targets: ["AppFeature"]
        ),
        .library(
            name: "CounterFeature",
            targets: ["CounterFeature"]
        ),
        .library(
            name: "SettingsFeature",
            targets: ["SettingsFeature"]
        ),
    ],
    dependencies: [
        // .package(url: "https://www.github.com/pointfreeco/swift-composable-architecture", from: "1.8.2"),
        .package(url: "https://www.github.com/pointfreeco/swift-composable-architecture", branch: "shared-state-beta"),
    ],
    targets: [
        .target(
            name: "AppFeature",
            dependencies: [
                "CounterFeature",
                "SettingsFeature",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "CounterFeature",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .testTarget(
            name: "CounterFeatureTests",
            dependencies: ["CounterFeature"]
        ),
        .target(
            name: "SettingsFeature",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
    ]
)
