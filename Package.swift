// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "MuPar",
    products: [
        .library(
            name: "MuPar",
            targets: ["MuPar"]),
    ],
    dependencies: [
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "MuPar",
            dependencies: []),
        .testTarget(
            name: "MuParTests",
            dependencies: ["MuPar"]),
    ]
)
