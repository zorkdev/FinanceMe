#!/usr/bin/env swift

import Foundation

struct ResolvedPackages: Decodable {
    struct Object: Decodable {
        let pins: [Pin]
    }

    struct Pin: Decodable {
        let package: String
        let state: State
    }

    struct State: Decodable {
        let version: String
    }

    let object: Object
}

guard let package = CommandLine.arguments.dropFirst().first,
    let resolvedPackagesData = FileManager.default.contents(atPath: "Tools/Package.resolved"),
    let resolvedPackages = try? JSONDecoder().decode(ResolvedPackages.self, from: resolvedPackagesData),
    let pin = resolvedPackages.object.pins.first(where: { $0.package.lowercased() == package.lowercased() }) else {
        print("Could not find package in Package.resolved.")
        exit(1)
}

print(pin.state.version)
exit(0)
