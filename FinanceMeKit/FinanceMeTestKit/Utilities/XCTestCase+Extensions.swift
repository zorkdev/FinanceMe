import XCTest

public extension XCTestCase {
    func waitUntil(action: @escaping (@escaping () -> Void) -> Void) {
        let newExpectation = expectation(description: "New expectation")
        action { newExpectation.fulfill() }
        waitForExpectations(timeout: 10, handler: nil)
    }
}

open class ServiceClientTestCase: XCTestCase {
    public var appState: MockAppState!

    override open func setUp() {
        super.setUp()
        appState = MockAppState()
    }
}
