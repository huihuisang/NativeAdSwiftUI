// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NativeAdSwiftUI",
    platforms: [
        .iOS(.v14),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "NativeAdSwiftUI",
            type: .dynamic,
            targets: ["NativeAdSwiftUI"]
        ),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/googleads/swift-package-manager-google-mobile-ads.git", .upToNextMajor(from: "11.9.0")),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "NativeAdSwiftUI",
            dependencies: [
                .product(name: "GoogleMobileAds", package: "swift-package-manager-google-mobile-ads"),
            ],
            resources: [.process("Resources")],
            linkerSettings: [
                .unsafeFlags(["-all_load"]),
            ]
        ),
        .testTarget(
            name: "NativeAdSwiftUITests",
            dependencies: ["NativeAdSwiftUI"]
        ),
    ]
)
