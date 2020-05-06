// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "GiphyKit",
  platforms: [
    .macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6)
  ],
  products: [
    .library(name: "GiphyKit", targets: ["GiphyKit"])
  ],
  dependencies: [
    .package(url: "https://github.com/adamayoung/Cache.git", from: "1.0.0")
  ],
  targets: [
    .target(name: "GiphyKit", dependencies: ["Cache"]),
    .testTarget(name: "GiphyKitTests", dependencies: ["GiphyKit"])
  ]
)
