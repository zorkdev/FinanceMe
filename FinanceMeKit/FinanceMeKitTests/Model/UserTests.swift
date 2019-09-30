import XCTest
import FinanceMeTestKit
@testable import FinanceMeKit

class UserTests: XCTestCase {
    func testCoding() throws {
        try assert(model: User.self, json:
            """
            {
              "balance" : 211.2,
              "allowance" : 100.22,
              "startDate" : "2019-01-01T00:00:00Z",
              "name" : "Name",
              "payday" : 10,
              "largeTransaction" : 10
            }
            """)
    }
}
