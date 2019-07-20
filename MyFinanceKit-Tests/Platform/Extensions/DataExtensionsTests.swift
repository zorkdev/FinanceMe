@testable import MyFinanceKit

class DataExtensionsTests: XCTestCase {
    func testPrettyPrinted_Success() {
        let data = "{\"key\":\"value\"}".data(using: .utf8)

        let prettyPrinted = data?.prettyPrinted

        let expectedValue =
        """
        {
          "key" : "value"
        }
        """

        XCTAssertEqual(prettyPrinted, expectedValue)
    }

    func testPrettyPrinted_Failure() {
        let data = ".......".data(using: .utf8)

        let prettyPrinted = data?.prettyPrinted

        let expectedValue = "nil"

        XCTAssertEqual(prettyPrinted, expectedValue)
    }
}
