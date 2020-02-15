// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "Tools",
    dependencies: [
        .package(url: "https://github.com/realm/SwiftLint.git", from: "0.39.1")
    ],
    targets: [
        .target(name: "Tools", dependencies: ["swiftlint"])
    ]
)
