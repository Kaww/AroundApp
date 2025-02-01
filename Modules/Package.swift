// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

enum Dependency {}

let package = Package(
  name: "Modules",
  defaultLocalization: "en",
  platforms: [.iOS(.v18)],
  products: [
    .library(name: "App", targets: ["App"]),
  ],
  dependencies: [],
  targets: [
    // MARK: - App
    .target(
      name: "App",
      dependencies: []
    ),
    .testTarget(
      name: "AppTests",
      dependencies: [
        "App"
      ]
    )
  ]
)
