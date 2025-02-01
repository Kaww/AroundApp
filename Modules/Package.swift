// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

enum Dependency {}

let package = Package(
  name: "Modules",
  defaultLocalization: "en",
  platforms: [.iOS(.v18)],
  products: [
    .library(name: "BaseApp", targets: ["BaseApp"]),
    .library(name: "MapPictures", targets: ["MapPictures"]),
    .library(name: "Models", targets: ["Models"]),
  ],
  dependencies: [],
  targets: [
    // Note: Targets are sorted alphabetically like in the `Sources` and `Tests` folders.

    // MARK: - Base App
    .target(
      name: "BaseApp",
      dependencies: [
        "MapPictures"
      ]
    ),
    .testTarget(
      name: "BaseAppTests",
      dependencies: [
        "BaseApp"
      ]
    ),

    // MARK: - Map Pictures
    .target(
      name: "MapPictures",
      dependencies: [
        "Models"
      ]
    ),
    .testTarget(
      name: "MapPicturesTests",
      dependencies: [
        "MapPictures"
      ]
    ),

    // MARK: - Models
    .target(
      name: "Models",
      dependencies: []
    ),
    .testTarget(
      name: "ModelsTests",
      dependencies: [
        "Models"
      ]
    )
  ]
)
