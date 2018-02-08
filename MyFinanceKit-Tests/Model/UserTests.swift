@testable import MyFinanceKit

class UserTests: XCTestCase {

    func testDecodeUser() {
        let jsonData =
        """
        {
            "token": "token",
            "name": "User Name",
            "startDate": "2018-01-01T00:00:00.000Z",
            "id": "id",
            "largeTransaction": 10,
            "payday": 10,
            "allowance": 100.22
        }
        """.data(using: .utf8)!

        XCTAssertNotNil(User(data: jsonData))
    }

    func testEncodeUser() {
        let user = User(name: "User Name",
                        payday: 10,
                        startDate: Date(),
                        largeTransaction: 10,
                        allowance: 100.22)

        XCTAssertNotNil(user.encoded())
    }

}
