import XCTest
import FinanceMeTestKit
@testable import FinanceMeKit

class APITests: XCTestCase {
    func testAPI() {
        XCTAssertEqual(API.login.url.absoluteString,
                       "https://zorkdev-staging.herokuapp.com/api/login")
        XCTAssertEqual(API.user.url.absoluteString,
                       "https://zorkdev-staging.herokuapp.com/api/users/me")
        XCTAssertEqual(API.transactions.url.absoluteString,
                       "https://zorkdev-staging.herokuapp.com/api/transactions")
        XCTAssertEqual(API.endOfMonthSummaries.url.absoluteString,
                       "https://zorkdev-staging.herokuapp.com/api/endOfMonthSummaries")
        XCTAssertEqual(API.reconcile.url.absoluteString,
                       "https://zorkdev-staging.herokuapp.com/api/reconcile")
        XCTAssertEqual(API.deviceToken.url.absoluteString,
                       "https://zorkdev-staging.herokuapp.com/api/deviceToken")

        let uuid = UUID()
        XCTAssertEqual(API.transaction(uuid).url.absoluteString,
                       "https://zorkdev-staging.herokuapp.com/api/transactions/\(uuid.uuidString)")
    }
}