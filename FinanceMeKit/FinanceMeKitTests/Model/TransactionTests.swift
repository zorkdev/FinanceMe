import XCTest
import FinanceMeTestKit
@testable import FinanceMeKit

class TransactionTests: XCTestCase {
    func testCoding() throws {
        try assert(model: Transaction.self, json:
            """
            {
              "amount" : 110.42,
              "id" : "D7438025-A56B-47B8-BF62-0E4D38CD5A46",
              "created" : "2019-01-01T00:00:00Z",
              "source" : "EXTERNAL_OUTBOUND",
              "narrative" : "Transaction",
              "direction" : "OUTBOUND"
            }
            """)
    }
}
