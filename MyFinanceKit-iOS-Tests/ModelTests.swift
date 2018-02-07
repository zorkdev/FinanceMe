@testable import MyFinanceKit

class ModelTests: XCTestCase {

    func testDecodingUser() {
        let jsonData =
        """
        {
            "token": "token",
            "name": "User Name",
            "startDate": "2017-01-01T00:00:00.000Z",
            "id": "id",
            "largeTransaction": 10,
            "payday": 10,
            "allowance": 100.22
        }
        """.data(using: .utf8)!

        XCTAssertNotNil(User(data: jsonData))
    }

    func testEncodingUser() {
        let user = User(name: "User Name",
                        payday: 10,
                        startDate: Date(),
                        largeTransaction: 10,
                        allowance: 100.22)

        XCTAssertNotNil(user.encoded())
    }

    func testDecodingBalance() {
        let jsonData =
            """
        {
            "token": "token",
            "name": "User Name",
            "startDate": "2017-01-01T00:00:00.000Z",
            "id": "id",
            "largeTransaction": 10,
            "payday": 10,
            "allowance": 100.22
        }
        """.data(using: .utf8)!

        XCTAssertNotNil(User(data: jsonData))
    }

    func testEncodingBalance() {
        let user = User(name: "User Name",
                        payday: 10,
                        startDate: Date(),
                        largeTransaction: 10,
                        allowance: 100.22)

        XCTAssertNotNil(user.encoded())
    }

}
