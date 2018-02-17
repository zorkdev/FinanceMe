@testable import MyFinanceKit

class UserBusinessLogicTests: XCTestCase {

    func testGetCurrentUser() {
        let newExpectation = expectation(description: "Current user fetched")

        let userBusinessLogic = UserBusinessLogic()

        _ = userBusinessLogic.getCurrentUser()
            .done { user in
                newExpectation.fulfill()
        }

        waitForExpectations(timeout: 10.0, handler: nil)
    }

    func testUpdateUser() {
        let newExpectation = expectation(description: "Current user updated")

        let userBusinessLogic = UserBusinessLogic()

        _ = userBusinessLogic.getCurrentUser()
            .then { user in
                userBusinessLogic.update(user: user).asVoid()
            }.done {
                newExpectation.fulfill()
        }

        waitForExpectations(timeout: 10.0, handler: nil)
    }
    
}
