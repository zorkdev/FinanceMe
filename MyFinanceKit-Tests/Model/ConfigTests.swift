@testable import MyFinanceKit

class ConfigTests: XCTestCase {

    func testDecodeConfig() {
        let jsonData =
        """
        {
            "starlingToken": "token",
            "zorkdevToken": "token"
        }
        """.data(using: .utf8)!

        XCTAssertNotNil(Config(data: jsonData))
    }

    func testEncodeConfig() {
        let config = Config(starlingToken: "token",
                          zorkdevToken: "token")

        XCTAssertNotNil(config.encoded())
    }

    func testURLEncodeConfig() {
        let config = Config(starlingToken: "token",
                            zorkdevToken: "token")

        print(String(data: config.urlEncoded()!, encoding: .utf8)!)

        XCTAssertNotNil(config.urlEncoded())
    }

}
