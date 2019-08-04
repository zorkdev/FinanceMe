import XCTest
@testable import FinanceMeKit

class URLSessionExtensionsTests: XCTestCase {
    func testPerform() {
        let request = URLRequest(url: URL(string: "https://www.apple.com")!)
        URLSession.shared.perform(request: request).assertSuccess(self) { _ in }
    }
}
