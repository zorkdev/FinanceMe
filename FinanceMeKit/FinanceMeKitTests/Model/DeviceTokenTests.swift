import XCTest
import FinanceMeTestKit
@testable import FinanceMeKit

class DeviceTokenTests: XCTestCase {
    func testCoding() throws {
        try assert(model: DeviceToken.self, json:
            """
            {
              "deviceToken" : "740F4707BEBCF74F"
            }
            """)
    }
}
