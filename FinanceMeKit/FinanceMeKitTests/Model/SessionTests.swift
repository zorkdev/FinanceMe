import XCTest
import FinanceMeTestKit
@testable import FinanceMeKit

class SessionTests: XCTestCase {
    func testDecode() {
        let jsonData =
            """
            {
                "sToken": "sToken",
                "token": "token"
            }
            """.data(using: .utf8)!

        let expectedValue = Factory.makeSession()

        do {
            let value = try Session(from: jsonData)
            XCTAssertEqual(value, expectedValue)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testEncode() {
        let value = Factory.makeSession()

        let expectedValue =
            """
            {
              "token" : "token",
              "sToken" : "sToken"
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
