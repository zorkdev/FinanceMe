import XCTest
import FinanceMeTestKit
@testable import FinanceMeKit

class SessionTests: XCTestCase {
    func testDecode() {
        let jsonData =
            """
            {
                "token": "token"
            }
            """.data(using: .utf8)!

        let expectedValue = Session.stub

        do {
            let value = try Session(from: jsonData)
            XCTAssertEqual(value, expectedValue)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testEncode() {
        let value = Session.stub

        let expectedValue =
            """
            {
              "token" : "token"
            }
            """

        switch value.jsonEncoded(prettyPrinted: true) {
        case .success(let data):
            let string = String(data: data, encoding: .utf8)!
            XCTAssertEqual(string, expectedValue)
        case .failure(let error):
            XCTFail(error.localizedDescription)
        }
    }
}
