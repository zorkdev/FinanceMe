@testable import MyFinanceKit

class HALResponseTests: XCTestCase {

    func testDecodeHALResponse() {
        let jsonData =
        """
        {
            "_embedded": {
                "key": "value"
            }
        }
        """.data(using: .utf8)!

        XCTAssertNotNil(HALResponse<[String: String]>(data: jsonData))
    }

    func testDecodeHALResponseFailure() {
        let jsonData =
        """
        {
            "key": "value"
        }
        """.data(using: .utf8)!

        XCTAssertNil(HALResponse<[String: String]>(data: jsonData))
    }

    func testEncodeHALResponse() {
        let embedded = ["key": "value"]
        let halResponse = HALResponse(embedded: embedded)

        XCTAssertNotNil(halResponse.encoded())
    }

}
