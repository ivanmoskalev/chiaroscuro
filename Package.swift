// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Chiaroscuro",
    platforms: [
        .iOS(.v17),
    ],
    products: [
        .library(name: "Chiaroscuro", type: .dynamic, targets: ["Chiaroscuro"]),
        .library(name: "ChiaroscuroSyncIndicator", type: .dynamic, targets: ["ChiaroscuroSyncIndicator"]),
    ],
    targets: [
        .target(name: "Chiaroscuro"),
        .target(name: "ChiaroscuroSyncIndicator"),
    ]
)
