import XCTest
@testable import FinanceMeKit

class CodableExtensionsTests: XCTestCase {
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

        switch model.jsonEncoded() {
        case .success(let data):
            let string = String(data: data, encoding: .utf8)!
            XCTAssertEqual(string, expectedValue)
        case .failure(let error):
            XCTFail(error.localizedDescription)
        }
    }

    func testEncode_Failure() {
        XCTAssertThrowsError(try Double.nan.jsonEncoded().get())
    }

    func testEncodePrettyPrinted() {
        let dict = ["key": "value"]
        let expectedValue =
            """
            {
              "key" : "value"
            }
            """

        switch dict.jsonEncoded(prettyPrinted: true) {
        case .success(let data):
            let string = String(data: data, encoding: .utf8)!
            XCTAssertEqual(string, expectedValue)
        case .failure(let error):
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
