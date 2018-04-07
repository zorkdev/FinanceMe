@testable import MyFinanceKit

class UserBusinessLogicTests: IntegrationTestCase {

    func testGetSession() {
        let newExpectation = expectation(description: "User logged in")

        config.appState.dataService.removeAll()

        let userBusinessLogic = UserBusinessLogic(networkService: config.appState.networkService,
                                                  dataService: config.appState.dataService)

        _ = userBusinessLogic.getSession(credentials: config.testCredentials)
            .done { _ in
                newExpectation.fulfill()
        }

        waitForExpectations(timeout: 10.0, handler: nil)
    }

    func testGetCurrentUser() {
        let newExpectation = expectation(description: "Current user fetched")

        let userBusinessLogic = UserBusinessLogic(networkService: config.appState.networkService,
                                                  dataService: config.appState.dataService)

        _ = userBusinessLogic.getCurrentUser()
            .done { _ in
                newExpectation.fulfill()
        }

        waitForExpectations(timeout: 10.0, handler: nil)
    }

    func testUpdateUser() {
        let newExpectation = expectation(description: "Current user updated")

        let userBusinessLogic = UserBusinessLogic(networkService: config.appState.networkService,
                                                  dataService: config.appState.dataService)

        _ = userBusinessLogic.getCurrentUser()
            .then { user in
                userBusinessLogic.update(user: user).asVoid()
            }.done {
                newExpectation.fulfill()
        }

        waitForExpectations(timeout: 10.0, handler: nil)
    }

}
