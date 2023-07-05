// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "MuPar",
    products: [
        .library(
            name: "MuPar",
            targets: ["MuPar"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-collections.git", .upToNextMajor(from: "1.0.0")
                )
    ],
    targets: [
        .target(name: "MuPar",
            dependencies: [
                .product(name: "Collections", package: "swift-collections")
            ]),
        .testTarget(
            name: "MuParTests",
            dependencies: ["MuPar"]),
    ]
)
