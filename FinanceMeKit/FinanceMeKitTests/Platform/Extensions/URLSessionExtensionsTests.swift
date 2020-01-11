import XCTest
import FinanceMeTestKit
@testable import FinanceMeKit

final class URLSessionExtensionsTests: AsyncTestCase {
    func testPerform() {
        let request = URLRequest(url: URL(string: "https://www.apple.com")!)
        URLSession.shared.perform(request: request).assertSuccess(self, once: false) { _ in }
    }
}
