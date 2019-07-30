import XCTest
@testable import FinanceMeKit

class CodableExtensionsTests: XCTestCase {
    struct Model: Codable {
        var string: String
        var date: Date
    }

    func testDecode_Success() {
        let dateString = "2019-01-01T00:00:00Z"
        let date = ISO8601DateFormatter().date(from: dateString)!
        let jsonData =
            """
            {
                "string": "value",
                "date": "\(dateString)"
            }
            """.data(using: .utf8)!

        do {
            let model = try Model(from: jsonData)
            XCTAssertEqual(model.string, "value")
            XCTAssertEqual(model.date, date)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testDecode_Failure() {
        let jsonData =
            """
            {
                "string": 1,
                "date": "2019-01-01T00:00:00Z"
            }
            """.data(using: .utf8)!

        XCTAssertThrowsError(try Model(from: jsonData))
    }

    func testEncode_Success() {
        let dateString = "2019-01-01T00:00:00Z"
        let date = ISO8601DateFormatter().date(from: dateString)!
        let expectedValue =
            """
            {"string":"value","date":"2019-01-01T00:00:00Z"}
            """

        let model = Model(string: "value",
                          date: date)

        do {
            let data = try model.jsonEncoded()
            let string = String(data: data, encoding: .utf8)
            XCTAssertEqual(string, expectedValue)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testEncode_Failure() {
        XCTAssertThrowsError(try Double.nan.jsonEncoded())
    }

    func testEncodePrettyPrinted() {
        let dict = ["key": "value"]
        let expectedValue =
            """
            {
              "key" : "value"
            }
            """

        do {
            let data = try dict.jsonEncoded(prettyPrinted: true)
            let string = String(data: data, encoding: .utf8)
            XCTAssertEqual(string, expectedValue)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testPrettyPrinted_Success() {
        let dict = ["key": "value"]
        let prettyPrinted = dict.prettyPrinted
        let expectedValue =
            """
            {
              "key" : "value"
            }
            """

        XCTAssertEqual(prettyPrinted, expectedValue)
    }

    func testPrettyPrinted_Failure() {
        let nan = Double.nan
        let prettyPrinted = nan.prettyPrinted

        XCTAssertEqual(prettyPrinted, "nil")
    }
}
