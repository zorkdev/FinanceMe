@testable import MyFinanceKit

class UserBusinessLogicTests: XCTestCase {

    var mockNetworkService = MockNetworkService()
    var mockDataService = MockDataService()

    override func tearDown() {
        super.tearDown()

        mockNetworkService = MockNetworkService()
        mockDataService = MockDataService()
    }

    func testGetCurrentUser() {
        let newExpectation = expectation(description: "User fetched")

        let expectedUser = User(name: "User Name",
                                payday: 10,
                                startDate: Date(),
                                largeTransaction: 10,
                                allowance: 100.22)

        mockNetworkService.returnJSONDecodableValues = [expectedUser]

        let userBusinessLogic = UserBusinessLogic(networkService: mockNetworkService,
                                                  dataService: mockDataService)

        _ = userBusinessLogic.getCurrentUser().done { user in

            XCTAssertEqual(self.mockNetworkService.lastRequest?.api as? API, .zorkdev(.user))
            XCTAssertEqual(self.mockNetworkService.lastRequest?.method, .get)
            XCTAssertNil(self.mockNetworkService.lastRequest?.parameters)
            XCTAssertNil(self.mockNetworkService.lastRequest?.body)
            XCTAssertEqual(user, expectedUser)
            XCTAssertEqual(self.mockDataService.lastSavedValue as? User, expectedUser)

            newExpectation.fulfill()
        }

        waitForExpectations(timeout: 10.0, handler: nil)
    }

    func testUpdateUser() {
        let newExpectation = expectation(description: "User updated")

        let expectedUser = User(name: "User Name",
                                payday: 10,
                                startDate: Date(),
                                largeTransaction: 10,
                                allowance: 100.22)

        mockNetworkService.returnJSONDecodableValues = [expectedUser]

        let userBusinessLogic = UserBusinessLogic(networkService: mockNetworkService,
                                                  dataService: mockDataService)

        _ = userBusinessLogic.update(user: expectedUser).done { user in

            XCTAssertEqual(self.mockNetworkService.lastRequest?.api as? API, .zorkdev(.user))
            XCTAssertEqual(self.mockNetworkService.lastRequest?.method, .patch)
            XCTAssertNil(self.mockNetworkService.lastRequest?.parameters)
            XCTAssertEqual(self.mockNetworkService.lastRequest?.body as? User, expectedUser)
            XCTAssertEqual(user, expectedUser)
            XCTAssertEqual(self.mockDataService.lastSavedValue as? User, expectedUser)

            newExpectation.fulfill()
        }

        waitForExpectations(timeout: 10.0, handler: nil)
    }

}
