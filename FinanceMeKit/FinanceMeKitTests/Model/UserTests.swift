import XCTest
import FinanceMeTestKit
@testable import FinanceMeKit

class UserTests: XCTestCase {
    func testDecode() {
        let jsonData =
            """
            {
                "name": "Name",
                "payday": 10,
                "startDate": "2019-01-01T00:00:00Z",
                "largeTransaction": 10,
                "allowance": 100.22,
                "balance" : 211.2
            }
            """.data(using: .utf8)!

        let expectedValue = User.stub

        do {
            let value = try User(from: jsonData)
            XCTAssertEqual(value, expectedValue)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testEncode() {
        let value = User.stub

        let expectedValue =
            """
            {
              "balance" : 211.2,
              "allowance" : 100.22,
              "startDate" : "2019-01-01T00:00:00Z",
              "name" : "Name",
              "payday" : 10,
              "largeTransaction" : 10
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
