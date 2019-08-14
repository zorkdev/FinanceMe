import XCTest
import SwiftUI

public extension XCTestCase {
    func waitUntil(action: @escaping (@escaping () -> Void) -> Void) {
        let newExpectation = expectation(description: "New expectation")
        action { newExpectation.fulfill() }
        waitForExpectations(timeout: 10, handler: nil)
    }

    func waitForEvent(action: @escaping () -> Void) {
        waitUntil { done in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                action()
                done()
            }
        }
    }

    func assert<T: View, U: PreviewProvider>(view: T, previews: U.Type) {
        XCTAssertNotNil(previews.previews)

        #if canImport(UIKit)
        let window = UIWindow()
        window.rootViewController = UIHostingController(rootView: view)
        window.makeKeyAndVisible()

        #elseif canImport(AppKit)
        let window = NSWindow()
        window.contentView = NSHostingView(rootView: view)
        window.makeKeyAndOrderFront(nil)
        #endif
    }
}

open class ServiceClientTestCase: XCTestCase {
    public var appState: MockAppState!

    override open func setUp() {
        super.setUp()
        appState = MockAppState()
    }
}
