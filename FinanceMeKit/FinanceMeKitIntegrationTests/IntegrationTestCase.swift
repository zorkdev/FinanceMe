import XCTest
import FinanceMeTestKit
@testable import FinanceMeKit

class IntegrationTestCase: XCTestCase {
    var appState: AppState!

    let credentials = Credentials(email: "test@test.com", password: "test")

    override func setUp() {
        super.setUp()
        appState = AppState()
        appState.sessionBusinessLogic.login(credentials: credentials).assertSuccess(self) { _ in }
    }

    override func tearDown() {
        super.tearDown()
        appState.dataService.removeAll()
    }
}
