import XCTest
import FinanceMeTestKit
@testable import FinanceMeKit

final class HomeToolbarTests: XCTestCase {
    var appState: MockAppState!
    var loadingState: LoadingState!
    var errorViewModel: ErrorViewModel!
    var selectionState: SelectionState!
    var toolbar: HomeToolbar!

    override func setUp() {
        super.setUp()
        appState = MockAppState()
        loadingState = LoadingState()
        errorViewModel = ErrorViewModel()
        selectionState = SelectionState()
        toolbar = HomeToolbar(appState: appState,
                              loadingState: loadingState,
                              errorViewModel: errorViewModel,
                              selectionState: selectionState)
    }

    func testAllowedItemIdentifiers() {
        XCTAssertEqual(toolbar.toolbarAllowedItemIdentifiers(NSToolbar()), [
            "refreshItem",
            "loadingItem",
            "segmentedControlItem",
            "newTransactionItem",
            .flexibleSpace
        ])
    }

    func testDefaultItemIdentifiers() {
        XCTAssertEqual(toolbar.toolbarDefaultItemIdentifiers(NSToolbar()), [
            "refreshItem",
            "loadingItem",
            .flexibleSpace,
            "segmentedControlItem",
            .flexibleSpace,
            "newTransactionItem"
        ])
    }

    func testItemForItemIdentifier() {
        XCTAssertNotNil(toolbar.toolbar(NSToolbar(),
                                        itemForItemIdentifier: "refreshItem",
                                        willBeInsertedIntoToolbar: true))

        XCTAssertNotNil(toolbar.toolbar(NSToolbar(),
                                        itemForItemIdentifier: "loadingItem",
                                        willBeInsertedIntoToolbar: true))

        XCTAssertNotNil(toolbar.toolbar(NSToolbar(),
                                        itemForItemIdentifier: "segmentedControlItem",
                                        willBeInsertedIntoToolbar: true))

        XCTAssertNotNil(toolbar.toolbar(NSToolbar(),
                                        itemForItemIdentifier: "newTransactionItem",
                                        willBeInsertedIntoToolbar: true))

        XCTAssertNil(toolbar.toolbar(NSToolbar(),
                                     itemForItemIdentifier: "nonValidIdentifier",
                                     willBeInsertedIntoToolbar: true))
    }

    func testOnTapRefresh() {
        toolbar.onTapRefresh(NSButton())

        waitForEvent {}

        XCTAssertTrue(appState.mockUserBusinessLogic.didCallGetUser)
    }

    func testOnSelectedSegment() {
        let segmentedControl = NSSegmentedControl()
        segmentedControl.selectedSegment = 1

        toolbar.onSelectedSegment(segmentedControl)

        XCTAssertEqual(selectionState.selectedSegment, 1)
    }

    func testOnTapNewTransaction() {
        toolbar.onTapNewTransaction(NSButton())

        XCTAssertEqual(NSApp.windows.last?.title, "Transaction Details")
    }
}

extension NSToolbarItem.Identifier: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.init(rawValue: value)
    }
}
