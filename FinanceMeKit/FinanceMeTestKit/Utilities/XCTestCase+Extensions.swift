import XCTest
import SwiftUI
@testable import FinanceMeKit

public extension XCTestCase {
    func waitUntil(action: @escaping (@escaping () -> Void) -> Void) {
        let newExpectation = expectation(description: "New expectation")
        action { newExpectation.fulfill() }
        waitForExpectations(timeout: 10, handler: nil)
    }

    func waitForEvent(action: @escaping () -> Void) {
        waitUntil { done in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                action()
                done()
            }
        }
    }

    func assert<T: View>(view: T) {
        #if canImport(UIKit)
        let window = UIWindow()
        window.rootViewController = UIHostingController(rootView: view)
        window.makeKeyAndVisible()

        #elseif canImport(AppKit)
        let window = NSWindow()
        window.contentView = NSHostingView(rootView: view)
        window.makeKeyAndOrderFront(nil)
        #endif

        waitForEvent {}
    }

    func assert<T: View, U: PreviewProvider>(view: T, previews: U.Type) {
        XCTAssertNotNil(previews.previews)
        assert(view: view)
    }

    func assert<T: Codable & Equatable & Stubable>(model: T.Type, json: String) throws {
        let value = try T(from: json.data(using: .utf8)!)
        XCTAssertEqual(value, T.stub)

        let data = try T.stub.jsonEncoded(prettyPrinted: true).get()
        let string = String(data: data, encoding: .utf8)!
        XCTAssertEqual(string, json)
    }
}
