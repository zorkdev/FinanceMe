@testable import MyFinanceKit

class SummaryTests: XCTestCase {

    func testDecodeEndOfMonthSummary() {
        let jsonData =
        """
        {
            "balance": 100,
            "id": "id",
            "created": "2018-01-01T00:00:00.000Z"
        }
        """.data(using: .utf8)!

        XCTAssertNotNil(EndOfMonthSummary(data: jsonData))
    }

    func testEncodeEndOfMonthSummary() {
        let endOfMonthSummary = EndOfMonthSummary(balance: 100,
                                                  created: Date())

        XCTAssertNotNil(endOfMonthSummary.encoded())
    }

    func testDecodeCurrentMonthSummary() {
        let jsonData =
        """
        {
            "forecast" : -50.12,
            "allowance" : 100
        }
        """.data(using: .utf8)!

        XCTAssertNotNil(CurrentMonthSummary(data: jsonData))
    }

    func testEncodeCurrentMonthSummary() {
        let currentMonthSummary = CurrentMonthSummary(allowance: 100,
                                                      forecast: -50.12)

        XCTAssertNotNil(currentMonthSummary.encoded())
    }

    func testDecodeEndOfMonthSummaryList() {
        let jsonData =
        """
        {
            "currentMonthSummary" : {
                "forecast": -50.12,
                "allowance": 100
            },
            "endOfMonthSummaries": [
                {
                    "balance": 100,
                    "id": "id",
                    "created": "2018-01-01T00:00:00.000Z"
                },
            ]
        }
        """.data(using: .utf8)!

        XCTAssertNotNil(EndOfMonthSummaryList(data: jsonData))
    }

    func testEncodeEndOfMonthSummaryList() {
        let currentMonthSummary = CurrentMonthSummary(allowance: 100,
                                                      forecast: -50.12)

        let endOfMonthSummary = EndOfMonthSummary(balance: 100,
                                                  created: Date())

        let endOfMonthSummaryList = EndOfMonthSummaryList(currentMonthSummary: currentMonthSummary,
                                                          endOfMonthSummaries: [endOfMonthSummary])

        XCTAssertNotNil(endOfMonthSummaryList.encoded())
    }

}
