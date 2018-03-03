@testable import MyFinanceKit

class UserBusinessLogicTests: XCTestCase {

    func testGetCurrentUser() {
        print(config)
        let newExpectation = expectation(description: "Current user fetched")

        let userBusinessLogic = UserBusinessLogic(networkService: appState.networkService,
                                                  dataService: appState.dataService)

        _ = userBusinessLogic.getCurrentUser()
            .done { _ in
                newExpectation.fulfill()
        }

        waitForExpectations(timeout: 10.0, handler: nil)
    }

    func testUpdateUser() {
        print(config)
        let newExpectation = expectation(description: "Current user updated")

        let userBusinessLogic = UserBusinessLogic(networkService: appState.networkService,
                                                  dataService: appState.dataService)

        _ = userBusinessLogic.getCurrentUser()
            .then { user in
                userBusinessLogic.update(user: user).asVoid()
            }.done {
                newExpectation.fulfill()
        }

        waitForExpectations(timeout: 10.0, handler: nil)
    }

}
