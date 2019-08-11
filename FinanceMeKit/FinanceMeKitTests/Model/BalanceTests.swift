import XCTest
import FinanceMeTestKit
@testable import FinanceMeKit

class BalanceTests: XCTestCase {
    func testDecode() {
        let jsonData =
            """
            {
                "amount": 100,
                "pendingTransactions": 90.22,
                "effectiveBalance": 100.1,
                "acceptedOverdraft": 100,
                "clearedBalance": 100,
                "currency": "GBP",
                "availableToSpend": 100
            }
            """.data(using: .utf8)!

        let expectedValue = Balance.stub

        do {
            let value = try Balance(from: jsonData)
            XCTAssertEqual(value, expectedValue)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testEncode() {
        let value = Balance.stub

        let expectedValue =
            """
            {
              "effectiveBalance" : 100.1
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
