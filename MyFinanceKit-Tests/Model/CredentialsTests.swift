@testable import MyFinanceKit

class CredentialsTests: XCTestCase {
    func testDecodeCredentials() {
        let jsonData =
        """
        {
            "email": "test@test.com",
            "password": "test"
        }
        """.data(using: .utf8)!

        XCTAssertNotNil(Credentials(data: jsonData))
    }

    func testEncodeCredentials() {
        let session = Credentials(email: "test@test.com",
                                  password: "test")

        XCTAssertNotNil(session.encoded())
    }

    func testURLEncodeCredentials() {
        let session = Credentials(email: "test@test.com",
                                  password: "test")

        XCTAssertNotNil(session.urlEncoded())
    }
}
