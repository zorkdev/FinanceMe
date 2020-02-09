import XCTest
import FinanceMeTestKit
@testable import FinanceMeKit

final class MenuControllerTests: XCTestCase {
    var appState: MockAppState!
    var preferencesMenuItem: MockMenuItem!
    var newTransactionMenuItem: MockMenuItem!
    var controller: MenuController!

    override func setUp() {
        super.setUp()
        appState = MockAppState()
        preferencesMenuItem = MockMenuItem()
        newTransactionMenuItem = MockMenuItem()
        controller = MenuController(appState: appState,
                                    preferencesMenuItem: preferencesMenuItem,
                                    newTransactionMenuItem: newTransactionMenuItem)
    }

    func testBindings() {
        waitForEvent {}

        XCTAssertFalse(preferencesMenuItem.isEnabled)
        XCTAssertFalse(newTransactionMenuItem.isEnabled)

        appState.mockSessionBusinessLogic.isLoggedInReturnValue = true

        waitForEvent {}

        XCTAssertTrue(preferencesMenuItem.isEnabled)
        XCTAssertTrue(newTransactionMenuItem.isEnabled)
    }

    func testOnTapPreferences() {
        controller.onTapPreferences(NSButton())
        controller.onTapPreferences(NSButton())

        XCTAssertEqual(NSApp.windows.last?.title, "Preferences")
    }

    func testOnTapNewTransaction() {
        controller.onTapNewTransaction(NSButton())

        XCTAssertEqual(NSApp.windows.last?.title, "Transaction Details")
    }
}
