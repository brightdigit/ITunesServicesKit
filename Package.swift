// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ITunesServicesKit",
    platforms: [
      .macOS(.v10_15),
      .iOS(.v10),
      .tvOS(.v10),
      .watchOS(.v3)
    ],
    products: [
        .library(
            name: "ITunesServicesKit",
            targets: ["ITunesServicesKit"]),
    ],
    dependencies: [
      .package(url: "https://github.com/brightdigit/Prch", from: "0.1.0")
    ],
    targets: [
        .target(
            name: "ITunesServicesKit",
            dependencies: ["Prch"]),
        .testTarget(
            name: "ITunesServicesKitTests",
            dependencies: ["ITunesServicesKit"]),
    ]
)
