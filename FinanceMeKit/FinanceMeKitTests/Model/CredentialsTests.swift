import XCTest
import FinanceMeTestKit
@testable import FinanceMeKit

final class CredentialsTests: XCTestCase {
    func testCoding() throws {
        try assert(model: Credentials.self, json:
            """
            {
              "email" : "user@example.com",
              "password" : "password"
            }
            """)
    }
}
