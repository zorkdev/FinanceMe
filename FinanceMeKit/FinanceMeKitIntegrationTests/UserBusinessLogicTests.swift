import XCTest
@testable import FinanceMeKit

class UserBusinessLogicTests: IntegrationTestCase {
    func testGetUpdateUser() {
        appState.userBusinessLogic.getUser().assertSuccess(self, once: false) {}
        var userExpectation: User?
        appState.userBusinessLogic.user.assertSuccess(self) { userExpectation = $0 }

        guard let user = userExpectation else {
            XCTFail("Missing user.")
            return
        }

        appState.userBusinessLogic.update(user: user).assertSuccess(self, once: false) {}
    }
}
