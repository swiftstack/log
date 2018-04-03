// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "Log",
    products: [
        .library(name: "Log", targets: ["Log"])
    ],
    dependencies: [
        .package(
            url: "https://github.com/swift-stack/test.git",
            .branch("master"))
    ],
    targets: [
        .target(name: "Log"),
        .testTarget(name: "LogTests", dependencies: ["Log", "Test"])
    ]
)
