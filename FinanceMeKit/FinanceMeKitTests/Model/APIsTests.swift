import XCTest
import FinanceMeTestKit
@testable import FinanceMeKit

class APIsTests: XCTestCase {
    func testZorkdevAPI() {
        XCTAssertEqual(ZorkdevAPI.login.url.absoluteString,
                       "https://zorkdev.herokuapp.com/api/login")
        XCTAssertEqual(ZorkdevAPI.user.url.absoluteString,
                       "https://zorkdev.herokuapp.com/api/users/me")
        XCTAssertEqual(ZorkdevAPI.transactions.url.absoluteString,
                       "https://zorkdev.herokuapp.com/api/transactions")
        XCTAssertEqual(ZorkdevAPI.endOfMonthSummaries.url.absoluteString,
                       "https://zorkdev.herokuapp.com/api/endOfMonthSummaries")
        XCTAssertEqual(ZorkdevAPI.reconcile.url.absoluteString,
                       "https://zorkdev.herokuapp.com/api/reconcile")
        XCTAssertEqual(ZorkdevAPI.deviceToken.url.absoluteString,
                       "https://zorkdev.herokuapp.com/api/deviceToken")

        let uuid = UUID()
        XCTAssertEqual(ZorkdevAPI.transaction(uuid).url.absoluteString,
                       "https://zorkdev.herokuapp.com/api/transactions/\(uuid.uuidString)")

        XCTAssertEqual(ZorkdevAPI.user.token(session: Factory.makeSession()), "token")
    }

    func testStarlingAPI() {
        XCTAssertEqual(StarlingAPI.balance.url.absoluteString,
                       "https://api.starlingbank.com/api/v1/accounts/balance")

        XCTAssertEqual(StarlingAPI.balance.token(session: Factory.makeSession()), "sToken")
    }
}
