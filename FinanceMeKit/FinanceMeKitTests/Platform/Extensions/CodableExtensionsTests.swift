import XCTest
@testable import FinanceMeKit

final class CodableExtensionsTests: XCTestCase {
    struct Model: Codable {
        var string: String
        var date: Date
    }

    func testDefaultJSONDecoder() {
        let decoder = JSONDecoder.default

        guard case .iso8601 = decoder.dateDecodingStrategy else {
            XCTFail("Wrong date decoding strategy.")
            return
        }
    }

    func testDecode_Success() throws {
        let dateString = "2019-01-01T00:00:00Z"
        let date = ISO8601DateFormatter().date(from: dateString)!
        let jsonData =
            """
            {
                "string": "value",
                "date": "\(dateString)"
            }
            """.data(using: .utf8)!

        let model = try Model(from: jsonData)
        XCTAssertEqual(model.string, "value")
        XCTAssertEqual(model.date, date)
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

    func testEncode_Success() throws {
        let dateString = "2019-01-01T00:00:00Z"
        let date = ISO8601DateFormatter().date(from: dateString)!
        let expectedValue =
            """
            {"string":"value","date":"2019-01-01T00:00:00Z"}
            """

        let model = Model(string: "value",
                          date: date)

        let data = try model.jsonEncoded().get()
        let string = String(data: data, encoding: .utf8)!
        XCTAssertEqual(string, expectedValue)
    }

    func testEncode_Failure() {
        XCTAssertThrowsError(try Double.nan.jsonEncoded().get())
    }

    func testEncodePrettyPrinted() throws {
        let dict = ["key": "value"]
        let expectedValue =
            """
            {
              "key" : "value"
            }
            """

        let data = try dict.jsonEncoded(prettyPrinted: true).get()
        let string = String(data: data, encoding: .utf8)!
        XCTAssertEqual(string, expectedValue)
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
