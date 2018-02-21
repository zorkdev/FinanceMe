@testable import MyFinanceKit

class AllowanceTests: XCTestCase {

    func testDecodeAllowance() {
        let jsonData =
        """
        {
            "allowance": 10,
        }
        """.data(using: .utf8)!

        XCTAssertNotNil(Allowance(data: jsonData))
    }

    func testEncodeAllowance() {
        let allowance = Allowance(allowance: 10.0)

        XCTAssertNotNil(allowance.encoded())
    }

    func testFormatted() {
        let allowance = Allowance(allowance: 10.0)

        XCTAssertEqual(allowance.formatted, "£10.00")
    }

}
