// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Chiaroscuro",
    platforms: [
        .iOS(.v16),
    ],
    products: [
        .library(name: "Chiaroscuro", targets: ["Chiaroscuro"]),
        .library(name: "ChiaroscuroSyncIndicator", targets: ["ChiaroscuroSyncIndicator"]),
    ],
    targets: [
        .target(name: "Chiaroscuro"),
        .target(name: "ChiaroscuroSyncIndicator"),
    ]
)
