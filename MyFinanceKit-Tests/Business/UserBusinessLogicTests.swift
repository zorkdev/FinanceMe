@testable import MyFinanceKit

class UserBusinessLogicTests: ServiceClientTestCase {

    func testGetSession() {
        let newExpectation = expectation(description: "Session fetched")

        let expectedSession = Factory.makeSession()
        let credentials = Credentials(email: "test@test.com", password: "test")

        mockAppState.mockNetworkService.returnJSONDecodableValues = [expectedSession]

        let userBusinessLogic = UserBusinessLogic(serviceProvider: mockAppState)

        _ = userBusinessLogic.getSession(credentials: credentials).done { session in

            XCTAssertEqual(self.mockAppState.mockNetworkService.lastRequest?.api as? API, .zorkdev(.login))
            XCTAssertEqual(self.mockAppState.mockNetworkService.lastRequest?.method, .post)
            XCTAssertNil(self.mockAppState.mockNetworkService.lastRequest?.parameters)
            XCTAssertEqual(self.mockAppState.mockNetworkService.lastRequest?.body as? Credentials, credentials)
            XCTAssertEqual(session, expectedSession)
            XCTAssertNotNil(self.mockAppState.mockSessionService.lastSaveValue)

            newExpectation.fulfill()
        }

        waitForExpectations(timeout: 10.0, handler: nil)
    }

    func testGetCurrentUser() {
        let newExpectation = expectation(description: "User fetched")

        let expectedUser = Factory.makeUser()

        mockAppState.mockNetworkService.returnJSONDecodableValues = [expectedUser]

        let userBusinessLogic = UserBusinessLogic(serviceProvider: mockAppState)

        _ = userBusinessLogic.getCurrentUser().done { user in

            XCTAssertEqual(self.mockAppState.mockNetworkService.lastRequest?.api as? API, .zorkdev(.user))
            XCTAssertEqual(self.mockAppState.mockNetworkService.lastRequest?.method, .get)
            XCTAssertNil(self.mockAppState.mockNetworkService.lastRequest?.parameters)
            XCTAssertNil(self.mockAppState.mockNetworkService.lastRequest?.body)
            XCTAssertEqual(user, expectedUser)
            XCTAssertTrue(self.mockAppState.mockDataService.savedValues
                .contains(where: { ($0 as? User) == expectedUser }) == true)

            newExpectation.fulfill()
        }

        waitForExpectations(timeout: 10.0, handler: nil)
    }

    func testUpdateUser() {
        let newExpectation = expectation(description: "User updated")

        let expectedUser = Factory.makeUser()

        mockAppState.mockNetworkService.returnJSONDecodableValues = [expectedUser]

        let userBusinessLogic = UserBusinessLogic(serviceProvider: mockAppState)

        _ = userBusinessLogic.update(user: expectedUser).done { user in

            XCTAssertEqual(self.mockAppState.mockNetworkService.lastRequest?.api as? API, .zorkdev(.user))
            XCTAssertEqual(self.mockAppState.mockNetworkService.lastRequest?.method, .patch)
            XCTAssertNil(self.mockAppState.mockNetworkService.lastRequest?.parameters)
            XCTAssertEqual(self.mockAppState.mockNetworkService.lastRequest?.body as? User, expectedUser)
            XCTAssertEqual(user, expectedUser)
            XCTAssertTrue(self.mockAppState.mockDataService.savedValues
                .contains(where: { ($0 as? User) == expectedUser }) == true)

            newExpectation.fulfill()
        }

        waitForExpectations(timeout: 10.0, handler: nil)
    }

}
