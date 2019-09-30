import XCTest
import FinanceMeTestKit
@testable import FinanceMeKit

class SummaryTests: XCTestCase {
    func testCoding() throws {
        try assert(model: Summary.self, json:
            """
            {
              "currentMonthSummary" : {
                "forecast" : -65.5,
                "spending" : 250.71,
                "allowance" : 90.3
              },
              "endOfMonthSummaries" : [
                {
                  "balance" : 41.9,
                  "created" : "2019-01-01T00:00:00Z"
                }
              ]
            }
            """)
    }
}
