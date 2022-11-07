// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "starter-kit-concurrency",
    platforms: [
        .macOS("10.15")
    ],
    dependencies: [
        .package(url: "https://github.com/AndrewBarba/Compute", branch: "main"),
        .package(url: "https://github.com/JohnSundell/CollectionConcurrencyKit.git", branch: "main")
    ],
    targets: [
        .executableTarget(
            name: "starter-kit-concurrency",
            dependencies: ["Compute", "CollectionConcurrencyKit"]
        )
    ]
)
