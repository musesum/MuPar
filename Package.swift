// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "MuPar",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "MuPar",
            targets: ["MuPar"]),
    ],
    dependencies: [
        .package(url: "https://github.com/musesum/MuVisit.git", from: "0.23.0"),
    ],
    targets: [
        .target(name: "MuPar",
            dependencies: [
                .product(name: "MuVisit", package: "MuVisit"),
            ]),
        .testTarget(
            name: "MuParTests",
            dependencies: ["MuPar"]),
    ]
)
