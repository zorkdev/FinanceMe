@testable import MyFinanceKit

class SessionTests: XCTestCase {
    func testDecodeSession() {
        let jsonData =
        """
        {
            "token": "token",
            "sToken": "token"
        }
        """.data(using: .utf8)!

        XCTAssertNotNil(Session(data: jsonData))
    }

    func testEncodeSession() {
        let session = Session(starlingToken: "token",
                              zorkdevToken: "token")

        XCTAssertNotNil(session.encoded())
    }

    func testURLEncodeSession() {
        let session = Session(starlingToken: "token",
                              zorkdevToken: "token")

        XCTAssertNotNil(session.urlEncoded())
    }
}
