import XCTest
import FinanceMeTestKit
@testable import FinanceMeKit

class CredentialsTests: XCTestCase {
    func testDecode() {
        let jsonData =
            """
            {
                "email": "user@example.com",
                "password": "password"
            }
            """.data(using: .utf8)!

        let expectedValue = Credentials.stub

        do {
            let value = try Credentials(from: jsonData)
            XCTAssertEqual(value, expectedValue)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testEncode() {
        let value = Credentials.stub

        let expectedValue =
            """
            {
              "email" : "user@example.com",
              "password" : "password"
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
