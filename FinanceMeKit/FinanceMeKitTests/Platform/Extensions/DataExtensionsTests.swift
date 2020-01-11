import XCTest
@testable import FinanceMeKit

final class DataExtensionsTests: XCTestCase {
    func testPrettyPrinted_Success() {
        let data =
            """
            {"key":"value"}
            """.data(using: .utf8)

        let expectedValue =
            """
            {
              "key" : "value"
            }
            """

        XCTAssertEqual(data?.prettyPrinted, expectedValue)
    }

    func testPrettyPrinted_Failure() {
        let data = ".......".data(using: .utf8)
        let expectedValue = "nil"

        XCTAssertEqual(data?.prettyPrinted, expectedValue)
    }
}
