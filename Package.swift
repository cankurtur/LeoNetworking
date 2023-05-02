// swift-tools-version:5.6
import PackageDescription

let package = Package(
    name: "LeoNetworking",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "LeoNetworking",
            targets: ["LeoNetworking"])
    ],
    targets: [
        .binaryTarget(
            name: "LeoNetworking",
            path: "LeoNetworking.xcframework")
    ])
