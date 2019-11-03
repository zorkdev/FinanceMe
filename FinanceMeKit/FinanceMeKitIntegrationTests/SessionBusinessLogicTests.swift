import XCTest
@testable import FinanceMeKit

class SessionBusinessLogicTests: IntegrationTestCase {
    func testGetUpdateUser() {
        appState.sessionBusinessLogic.login(credentials: credentials).assertSuccess(self) {}
        appState.sessionBusinessLogic.isLoggedIn.assertSuccess(self) { XCTAssertTrue($0) }
    }
}
