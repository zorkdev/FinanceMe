import XCTest
import FinanceMeTestKit
@testable import FinanceMeKit

final class DataExtensionsTests: XCTestCase {
    func testPrettyPrinted_Success() {
        let data =
            """
            {"key":"value"}
            """.utf8Data

        let expectedValue =
            """
            {
              "key" : "value"
            }
            """

        XCTAssertEqual(data.prettyPrinted, expectedValue)
    }

    func testPrettyPrinted_Failure() {
        let expectedValue = "Non-JSON string"
        let data = expectedValue.utf8Data

        XCTAssertEqual(data.prettyPrinted, expectedValue)
    }
}
