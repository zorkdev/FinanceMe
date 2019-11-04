import XCTest
@testable import FinanceMeKit

class ErrorTests: XCTestCase {
    func testAPIError() {
        let json =
            """
            {
                "reason" : "Test error"
            }
            """.data(using: .utf8)!

        XCTAssertEqual(APIError(code: 100, response: json)?.code, 100)
        XCTAssertEqual(APIError(code: 300, response: json)?.code, 300)
        XCTAssertEqual(APIError(code: 400, response: json)?.code, 400)
        XCTAssertEqual(APIError(code: 401, response: json)?.code, 401)
        XCTAssertEqual(APIError(code: 403, response: json)?.code, 403)
        XCTAssertEqual(APIError(code: 404, response: json)?.code, 404)
        XCTAssertEqual(APIError(code: 500, response: json)?.code, 500)
        XCTAssertNil(APIError(code: 200, response: json))
        XCTAssertNil(APIError(code: 201, response: json))
        XCTAssertNil(APIError(code: 204, response: json))

        XCTAssertEqual(APIError(code: 100, response: json)?.reason, "Test error")
        XCTAssertEqual(APIError(code: 100, response: Data())?.reason, "Unknown error")

        XCTAssertEqual(APIError(code: 100, response: json)?.errorDescription, "Test error (100)")
    }
}
