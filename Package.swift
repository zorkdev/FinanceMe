// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "Tools",
    dependencies: [
        .package(url: "https://github.com/realm/SwiftLint.git", .upToNextMajor(from: "0.38.0"))
    ]
)
