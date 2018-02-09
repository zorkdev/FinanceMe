@testable import MyFinanceKit

class DictionaryExtensionsTests: XCTestCase {

    func testPrettyPrinted() {
        let dict = ["key": "value"]
        let prettyPrinted = dict.prettyPrinted
        let expectedValue =
        """
        {
          "key" : "value"
        }
        """

        XCTAssertEqual(prettyPrinted, expectedValue)
    }

    func testPrettyPrintedParsingError() {
        let dict = ["key": "value"]
        let prettyPrinted = dict.prettyPrinted
        let expectedValue =
        """
        {
          "key" : "value"
        }
        """

        XCTAssertEqual(prettyPrinted, expectedValue)
    }

}
