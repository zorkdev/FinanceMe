@testable import MyFinanceKit

class URLSessionExtensionsTests: XCTestCase {

    func testPerformRequest() {
        let newExpectation = expectation(description: "Request performed")

        let url = URL(string: "https://www.apple.com")!
        let request = URLRequest(url: url)

        _ = URLSession.shared.perform(request: request).done { _, _ in
            newExpectation.fulfill()
        }

        waitForExpectations(timeout: 10.0, handler: nil)
    }

}
