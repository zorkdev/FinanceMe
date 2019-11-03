#if DEBUG
import Foundation

#if !os(watchOS)
public let isUnitTesting = NSClassFromString("XCTest") != nil
#endif
let isTesting = ProcessInfo.processInfo.arguments.contains("isTesting")
enum Stub {}
#endif
