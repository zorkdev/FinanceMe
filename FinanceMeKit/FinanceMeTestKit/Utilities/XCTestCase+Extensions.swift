import XCTest
import SwiftUI
import FinanceMeKit

public extension XCTestCase {
    func waitUntil(action: @escaping (@escaping () -> Void) -> Void) {
        let newExpectation = expectation(description: "New expectation")
        action { newExpectation.fulfill() }
        waitForExpectations(timeout: 10, handler: nil)
    }

    func waitForEvent(action: @escaping () -> Void) {
        waitUntil { done in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                action()
                done()
            }
        }
    }

    func assert<T: View, U: PreviewProvider>(view: T, previews: U.Type) {
        XCTAssertNotNil(previews.previews)

        let injectedView = view.environmentObject(MockAppState() as AppState)

        #if canImport(UIKit)
        let window = UIWindow()
        window.rootViewController = UIHostingController(rootView: injectedView)
        window.makeKeyAndVisible()

        #elseif canImport(AppKit)
        let window = NSWindow()
        window.contentView = NSHostingView(rootView: injectedView)
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
