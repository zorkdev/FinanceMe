import XCTest
import FinanceMeTestKit
@testable import FinanceMeKit

final class RootControllerTests: XCTestCase {
    var appState: MockAppState!

    override func setUp() {
        super.setUp()
        appState = MockAppState()
    }

    func testBindings() {
        _ = RootController(application: NSApp,
                           appState: appState,
                           preferencesMenuItem: MockMenuItem(),
                           newTransactionMenuItem: MockMenuItem())

        waitForEvent {}

        XCTAssertEqual(NSApp.windows.last?.title, "Login")

        appState.mockSessionBusinessLogic.isLoggedInReturnValue = true

        waitForEvent {}

        XCTAssertEqual(NSApp.windows.last?.title, "FinanceMe")
    }
}
