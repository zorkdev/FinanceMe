#if DEBUG
import Foundation

#if !os(watchOS)
public let isUnitTesting = NSClassFromString("XCTest") != nil
#endif
public let isTesting = ProcessInfo.processInfo.arguments.contains("isTesting")
public enum Stub {}
#endif
