import XCTest
import FinanceMeTestKit
@testable import FinanceMeKit

class SessionTests: XCTestCase {
    func testCoding() throws {
        try assert(model: Session.self, json:
            """
            {
              "token" : "token"
            }
            """)
    }
}
