import XCTest
import FinanceMeTestKit
@testable import FinanceMeKit

final class SessionTests: XCTestCase {
    func testCoding() throws {
        try assert(model: Session.self, json:
            """
            {
              "token" : "token"
            }
            """)
    }
}
