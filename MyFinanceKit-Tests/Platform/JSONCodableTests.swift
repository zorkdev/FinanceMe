@testable import MyFinanceKit

class JSONCodableTests: XCTestCase {

    func testDecode_Success() {
        struct SampleJSON: JSONCodable {
            var string: String
            var bool: Bool
            var int: Int
            var double: Double
            var date: Date
        }

        let jsonData =
        """
        {
            "string": "value",
            "bool": true,
            "int": 1,
            "double": 1.1,
            "date": "2018-01-01T00:00:00.000Z"
        }
        """.data(using: .utf8)!

        XCTAssertNotNil(SampleJSON(data: jsonData))
    }

    func testDecode_Failure() {
        struct SampleJSON: JSONCodable {
            var string: String
        }

        let jsonData =
        """
        {
            "notAString": 1,
        }
        """.data(using: .utf8)!

        XCTAssertNil(SampleJSON(data: jsonData))
    }

    func testEncoded_Success() {
        let dict = ["key": "value"]
        let data = dict.encoded()
        let expectedValue = "{\"key\":\"value\"}".data(using: .utf8)

        XCTAssertEqual(data, expectedValue)
    }

    func testEncoded_Failure() {
        let nan = Double.nan
        let data = nan.encoded()

        XCTAssertNil(data)
    }

    func testEncodedPrettyPrinted() {
        let dict = ["key": "value"]
        let data = dict.encoded(prettyPrinted: true)
        let expectedValue =
        """
        {
          "key" : "value"
        }
        """.data(using: .utf8)

        XCTAssertEqual(data, expectedValue)
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

    func testURLFormEncoded_Success() {
        struct SampleJSON: JSONCodable {
            var string: String
            var bool: Bool
            var int: Int
            var double: Double
        }

        let sampleJSON = SampleJSON(string: "value",
                                    bool: true,
                                    int: 1,
                                    double: 1.1)

        let urlFormEncoded = sampleJSON.urlEncoded()!

        XCTAssertTrue(urlFormEncoded.contains(URLQueryItem(name: "string", value: "value")))
        XCTAssertTrue(urlFormEncoded.contains(URLQueryItem(name: "bool", value: "true")))
        XCTAssertTrue(urlFormEncoded.contains(URLQueryItem(name: "int", value: "1")))
        XCTAssertTrue(urlFormEncoded.contains(URLQueryItem(name: "double", value: "1.1")))
    }

    func testURLFormEncodedNaN_Failure() {
        let nan = Double.nan
        let urlFormEncoded = nan.urlEncoded()

        XCTAssertNil(urlFormEncoded)
    }

    func testURLFormEncodedNestedKeyed_Failure() {
        struct NestedModel: JSONCodable {
            var int: Int
        }

        struct Model: JSONCodable {
            var nestedModel: NestedModel
        }

        let model = Model(nestedModel: NestedModel(int: 2))

        let urlFormEncoded = model.urlEncoded()

        XCTAssertNil(urlFormEncoded)
    }

    func testURLFormEncodedUnkeyed_Failure() {
        struct NestedModel: JSONCodable {
            var int: Int
        }

        struct Model: JSONCodable {
            var nestedModel: [NestedModel]
        }

        let model = [Model(nestedModel: [NestedModel(int: 2)])]

        let urlFormEncoded = model.urlEncoded()

        XCTAssertNil(urlFormEncoded)
    }

}
