#if DEBUG
import Foundation

public let isUnitTesting = NSClassFromString("XCTest") != nil
public let isTesting = ProcessInfo.processInfo.arguments.contains("isTesting")
public enum Stub {}
#endif
