import XCTest
@testable import FinanceMeKit

final class SessionBusinessLogicTests: IntegrationTestCase {
    func testGetUpdateUser() {
        appState.sessionBusinessLogic.login(credentials: credentials).assertSuccess(self, once: false) {}
        appState.sessionBusinessLogic.isLoggedIn.assertSuccess(self) { XCTAssertTrue($0) }
    }
}
