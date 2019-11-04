import XCTest

class HomeUITests: BaseTestCase, Home {
    func testHomeJourney() {
        givenIAmOnHomeScreen()

        thenIShouldSeeFeedTab()
        thenIShouldSeeRegularsTab()
        thenIShouldSeeBalancesTab()
        thenICanRefresh()
    }

    func testTransactionJourney() {
        givenIAmOnHomeScreen()

        whenITapAddButton()
        thenIShouldSeeTransactionDetailsScreen()

        whenITapCancelButton()
        thenIShouldSeeHomeScreen()

        whenITapAddButton()
        thenSaveButtonShouldBe(enabled: false)

        whenIEnter(amount: "10")
        whenIEnter(description: "Transaction")
        thenSaveButtonShouldBe(enabled: true)

        whenITapSaveButton()
        thenIShouldSeeLoadingViewDisappear()
        thenIShouldSeeHomeScreen()
        thenIShouldSeeTransaction(description: "Transaction", amount: "£10.00")

        whenITapTransaction(description: "Transaction", amount: "£10.00")
        thenIShouldSeeTransactionDetailsScreen()
        thenSaveButtonShouldBe(enabled: false)

        whenIEnter(description: "Updated")
        thenSaveButtonShouldBe(enabled: true)

        whenITapSaveButton()
        thenIShouldSeeLoadingViewDisappear()

        whenITapCancelButton()
        thenIShouldSeeHomeScreen()
        thenICanDeleteTransaction(description: "Updated", amount: "£10.00")
    }

    func testRegularTransactionJourney() {
        givenIAmOnHomeScreen()
        thenIShouldSeeRegularsTab()

        whenITapAddButton()
        whenIEnter(amount: "100")
        whenIEnter(description: "Transaction")
        whenISelect(category: "Regular Incoming")
        whenITapSaveButton()
        thenIShouldSeeLoadingViewDisappear()
        thenIShouldSeeHomeScreen()
        thenICanDeleteTransaction(description: "Transaction", amount: "+£100.00")

        whenITapAddButton()
        whenIEnter(amount: "100")
        whenIEnter(description: "Transaction")
        whenISelect(category: "Regular Outgoing")
        whenITapSaveButton()
        thenIShouldSeeLoadingViewDisappear()
        thenIShouldSeeHomeScreen()
        thenICanDeleteTransaction(description: "Transaction", amount: "£100.00")
    }
}

protocol Home {}

extension Home where Self: BaseTestCase {
    private var transactionDetailsScreen: XCUIElement {
        app.staticTexts["Transaction Details"].firstMatch
    }

    private var feedTab: XCUIElement {
        app.tabBars.buttons["Feed"].firstMatch
    }

    private var regularsTab: XCUIElement {
        app.tabBars.buttons["Regulars"].firstMatch
    }

    private var balancesTab: XCUIElement {
        app.tabBars.buttons["Balances"].firstMatch
    }

    private var refreshButton: XCUIElement {
        app.buttons["Refresh"].firstMatch
    }

    private var addButton: XCUIElement {
        app.buttons["Add"].firstMatch
    }

    private var amountTextField: XCUIElement {
        app.textFields["£0.00"].firstMatch
    }

    private var descriptionTextField: XCUIElement {
        app.textFields["Groceries"].firstMatch
    }

    private var categoryButton: XCUIElement {
        app.buttons["Category"].firstMatch
    }

    private func transactionCell(description: String, amount: String) -> XCUIElement {
        app.staticTexts["\(description)\n\(amount)"].firstMatch
    }

    func whenITapAddButton() {
        XCTContext.runActivity(named: #function) { _ in
            addButton.tap()
        }
    }

    func whenIEnter(amount: String) {
        XCTContext.runActivity(named: #function) { _ in
            amountTextField.clearAndTypeText(amount)
        }
    }

    func whenIEnter(description: String) {
        XCTContext.runActivity(named: #function) { _ in
            descriptionTextField.clearAndTypeText(description)
        }
    }

    func whenISelect(category: String) {
        XCTContext.runActivity(named: #function) { _ in
            categoryButton.tap()
            app.buttons[category].tap()
        }
    }

    func whenITapTransaction(description: String, amount: String) {
        XCTContext.runActivity(named: #function) { _ in
            transactionCell(description: description, amount: amount).tap()
        }
    }

    func thenICanRefresh() {
        XCTContext.runActivity(named: #function) { _ in
            refreshButton.tap()
            sleep(5)
        }
    }

    func thenIShouldSeeTransactionDetailsScreen() {
        XCTContext.runActivity(named: #function) { _ in
            XCTAssertTrue(transactionDetailsScreen.exists, "Transaction details screen does not exist")
        }
    }

    func thenIShouldSeeFeedTab() {
        XCTContext.runActivity(named: #function) { _ in
            feedTab.tap()
        }
    }

    func thenIShouldSeeRegularsTab() {
        XCTContext.runActivity(named: #function) { _ in
            regularsTab.tap()
        }
    }

    func thenIShouldSeeBalancesTab() {
        XCTContext.runActivity(named: #function) { _ in
            balancesTab.tap()
        }
    }

    func thenIShouldSeeTransaction(description: String, amount: String) {
        XCTContext.runActivity(named: #function) { _ in
            XCTAssertTrue(transactionCell(description: description, amount: amount).exists, "Transaction does not exist")
        }
    }

    func thenICanDeleteTransaction(description: String, amount: String) {
        XCTContext.runActivity(named: #function) { _ in
            transactionCell(description: description, amount: amount).swipeLeft()
            app.buttons["Delete"].tap()
            sleep(5)
        }
    }
}
