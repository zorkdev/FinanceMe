import XCTest
import FinanceMeTestKit
@testable import FinanceMeKit

class APITests: XCTestCase {
    func testAPI() {
        XCTAssertEqual(API.login.url.absoluteString,
                       "https://zorkdev.herokuapp.com/api/login")
        XCTAssertEqual(API.user.url.absoluteString,
                       "https://zorkdev.herokuapp.com/api/users/me")
        XCTAssertEqual(API.transactions.url.absoluteString,
                       "https://zorkdev.herokuapp.com/api/transactions")
        XCTAssertEqual(API.summary.url.absoluteString,
                       "https://zorkdev.herokuapp.com/api/endOfMonthSummaries")
        XCTAssertEqual(API.reconcile.url.absoluteString,
                       "https://zorkdev.herokuapp.com/api/reconcile")
        XCTAssertEqual(API.deviceToken.url.absoluteString,
                       "https://zorkdev.herokuapp.com/api/deviceToken")
        XCTAssertEqual(API.metrics.url.absoluteString,
                       "https://zorkdev.herokuapp.com/api/metrics")

        let uuid = UUID()
        XCTAssertEqual(API.transaction(uuid).url.absoluteString,
                       "https://zorkdev.herokuapp.com/api/transactions/\(uuid.uuidString)")
    }
}
