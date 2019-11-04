#if DEBUG
import Foundation

#if !os(watchOS)
public let isUnitTesting = NSClassFromString("XCTest") != nil
#endif
let isTesting = ProcessInfo.processInfo.arguments.contains("isTesting")
let isLoggedIn = ProcessInfo.processInfo.arguments.contains("isLoggedIn")
let isLoggedOut = ProcessInfo.processInfo.arguments.contains("isLoggedOut")
enum Stub {}
#endif
