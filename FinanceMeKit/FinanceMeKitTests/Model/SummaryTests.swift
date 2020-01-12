import XCTest
import FinanceMeTestKit
@testable import FinanceMeKit

final class SummaryTests: XCTestCase {
    func testCoding() throws {
        try assert(model: Summary.self, json:
            """
            {
              "currentMonthSummary" : {
                "forecast" : -110.42,
                "spending" : 250.62,
                "allowance" : 100.34
              },
              "endOfMonthSummaries" : [
                {
                  "balance" : 250.62,
                  "savings" : 100.34,
                  "created" : "2018-01-01T00:00:00Z"
                },
                {
                  "balance" : 110.42,
                  "savings" : 1000.22,
                  "created" : "2019-02-01T00:00:00Z"
                }
              ]
            }
            """)
    }
}
