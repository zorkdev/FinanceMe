@testable import MyFinanceKit

class BalanceTests: XCTestCase {
    func testDecodeBalance() {
        let jsonData =
        """
        {
            "amount": 100,
            "pendingTransactions": 90.22,
            "effectiveBalance": 20,
            "acceptedOverdraft": 100,
            "clearedBalance": 100,
            "currency": "GBP",
            "availableToSpend": 100
        }
        """.data(using: .utf8)!

        XCTAssertNotNil(Balance(data: jsonData))
    }

    func testEncodeBalance() {
        let balance = Factory.makeBalance()

        XCTAssertNotNil(balance.encoded())
    }
}
