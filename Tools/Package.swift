// swift-tools-version:5.2
import PackageDescription

let package = Package(
    name: "Tools",
    dependencies: [
        .package(url: "https://github.com/realm/SwiftLint.git", from: "0.39.2")
    ],
    targets: [
        .target(name: "Tools", dependencies: [
            .product(name: "swiftlint", package: "SwiftLint")
        ])
    ]
)
