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
    .library(name: "Camera", targets: ["Camera"]),
    .library(name: "MapPictures", targets: ["MapPictures"]),
    .library(name: "Models", targets: ["Models"]),
    .library(name: "Pictures", targets: ["Pictures"]),
  ],
  dependencies: [],
  targets: [
    // Note: Targets are sorted alphabetically like in the `Sources` and `Tests` folders.

    // MARK: - Base App
    .target(
      name: "BaseApp",
      dependencies: [
        "Camera",
        "MapPictures",
        "Models",
        "Pictures"
      ]
    ),
    .testTarget(
      name: "BaseAppTests",
      dependencies: [
        "BaseApp"
      ]
    ),

    // MARK: - Camera
    .target(
      name: "Camera",
      dependencies: [
        "Models"
      ]
    ),
    .testTarget(
      name: "CameraTests",
      dependencies: [
        "Camera"
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
    ),

    // MARK: - Pictures
    .target(
      name: "Pictures",
      dependencies: [
        "Models"
      ]
    ),
    .testTarget(
      name: "PicturesTests",
      dependencies: [
        "Pictures"
      ]
    )
  ]
)
