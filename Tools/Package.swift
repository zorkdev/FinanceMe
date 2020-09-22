// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "Tools",
    dependencies: [
        .package(url: "https://github.com/realm/SwiftLint.git", from: "0.40.2")
    ],
    targets: [
        .target(name: "Tools", dependencies: [
            .product(name: "swiftlint", package: "SwiftLint")
        ])
    ]
)
