@testable import MyFinanceKit

class UserBusinessLogicTests: XCTestCase {

    var mockNetworkService = MockNetworkService()
    var mockDataService = MockDataService()
    var mockSessionService = MockSessionService()

    override func tearDown() {
        super.tearDown()

        mockNetworkService = MockNetworkService()
        mockDataService = MockDataService()
        mockSessionService = MockSessionService()
    }

    func testGetSession() {
        let newExpectation = expectation(description: "Session fetched")

        let expectedSession = Factory.makeSession()
        let credentials = Credentials(email: "test@test.com", password: "test")

        mockNetworkService.returnJSONDecodableValues = [expectedSession]

        let userBusinessLogic = UserBusinessLogic(networkService: mockNetworkService,
                                                  dataService: mockDataService,
                                                  sessionService: mockSessionService)

        _ = userBusinessLogic.getSession(credentials: credentials).done { session in

            XCTAssertEqual(self.mockNetworkService.lastRequest?.api as? API, .zorkdev(.login))
            XCTAssertEqual(self.mockNetworkService.lastRequest?.method, .post)
            XCTAssertNil(self.mockNetworkService.lastRequest?.parameters)
            XCTAssertEqual(self.mockNetworkService.lastRequest?.body as? Credentials, credentials)
            XCTAssertEqual(session, expectedSession)
            XCTAssertNotNil(self.mockSessionService.lastSaveValue)

            newExpectation.fulfill()
        }

        waitForExpectations(timeout: 10.0, handler: nil)
    }

    func testGetCurrentUser() {
        let newExpectation = expectation(description: "User fetched")

        let expectedUser = Factory.makeUser()

        mockNetworkService.returnJSONDecodableValues = [expectedUser]

        let userBusinessLogic = UserBusinessLogic(networkService: mockNetworkService,
                                                  dataService: mockDataService,
                                                  sessionService: mockSessionService)

        _ = userBusinessLogic.getCurrentUser().done { user in

            XCTAssertEqual(self.mockNetworkService.lastRequest?.api as? API, .zorkdev(.user))
            XCTAssertEqual(self.mockNetworkService.lastRequest?.method, .get)
            XCTAssertNil(self.mockNetworkService.lastRequest?.parameters)
            XCTAssertNil(self.mockNetworkService.lastRequest?.body)
            XCTAssertEqual(user, expectedUser)
            XCTAssertTrue(self.mockDataService.savedValues
                .contains(where: { ($0 as? User) == expectedUser }) == true)

            newExpectation.fulfill()
        }

        waitForExpectations(timeout: 10.0, handler: nil)
    }

    func testUpdateUser() {
        let newExpectation = expectation(description: "User updated")

        let expectedUser = Factory.makeUser()

        mockNetworkService.returnJSONDecodableValues = [expectedUser]

        let userBusinessLogic = UserBusinessLogic(networkService: mockNetworkService,
                                                  dataService: mockDataService,
                                                  sessionService: mockSessionService)

        _ = userBusinessLogic.update(user: expectedUser).done { user in

            XCTAssertEqual(self.mockNetworkService.lastRequest?.api as? API, .zorkdev(.user))
            XCTAssertEqual(self.mockNetworkService.lastRequest?.method, .patch)
            XCTAssertNil(self.mockNetworkService.lastRequest?.parameters)
            XCTAssertEqual(self.mockNetworkService.lastRequest?.body as? User, expectedUser)
            XCTAssertEqual(user, expectedUser)
            XCTAssertTrue(self.mockDataService.savedValues
                .contains(where: { ($0 as? User) == expectedUser }) == true)

            newExpectation.fulfill()
        }

        waitForExpectations(timeout: 10.0, handler: nil)
    }

}
