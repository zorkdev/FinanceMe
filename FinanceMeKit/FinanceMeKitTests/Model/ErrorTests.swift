import XCTest
@testable import FinanceMeKit

class ErrorTests: XCTestCase {
    func testHTTPError() {
        XCTAssertEqual(HTTPError(code: 100)?.code, 100)
        XCTAssertEqual(HTTPError(code: 300)?.code, 300)
        XCTAssertEqual(HTTPError(code: 400)?.code, 400)
        XCTAssertEqual(HTTPError(code: 401)?.code, 401)
        XCTAssertEqual(HTTPError(code: 403)?.code, 403)
        XCTAssertEqual(HTTPError(code: 404)?.code, 404)
        XCTAssertEqual(HTTPError(code: 500)?.code, 500)
        XCTAssertNil(HTTPError(code: 200))
        XCTAssertNil(HTTPError(code: 201))
        XCTAssertNil(HTTPError(code: 204))
    }
}
