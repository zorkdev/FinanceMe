import XCTest

class SettingsUITests: BaseTestCase, Settings {
    func testSettingsJourney() {
        givenIAmOnHomeScreen()
        whenITapSettingsButton()
        thenIShouldSeeSettingsScreen()

        whenITapDoneButton()
        thenIShouldSeeHomeScreen()

        whenITapSettingsButton()
        whenITapEditButton()
        thenIShouldSeeCancelButton()

        whenITapCancelButton()
        thenIShouldSeeEditButton()

        whenITapEditButton()
        thenSaveButtonShouldBe(enabled: false)

        let previousName = nameTextField.value as? String ?? ""

        whenIEnter(name: "Test User")
        thenSaveButtonShouldBe(enabled: true)

        whenITapSaveButton()
        thenIShouldSeeLoadingViewDisappear()
        thenIShouldSeeHomeScreen()

        whenITapSettingsButton()
        whenITapEditButton()
        whenIEnter(name: previousName)
        whenITapSaveButton()
        thenIShouldSeeLoadingViewDisappear()
        thenIShouldSeeHomeScreen()

        whenITapSettingsButton()
        thenICanReconcile()

        whenITapLogOutButton()
        thenIShouldSeeLoginScreen()
    }
}

protocol Settings {}

extension Settings where Self: BaseTestCase {
    private var settingsScreen: XCUIElement {
        app.staticTexts["Settings"].firstMatch
    }

    private var settingsButton: XCUIElement {
        app.buttons["Settings"].firstMatch
    }

    private var editButton: XCUIElement {
        app.buttons["Edit"].firstMatch
    }

    private var doneButton: XCUIElement {
        app.buttons["Done"].firstMatch
    }

    private var reconcileButton: XCUIElement {
        app.buttons["Reconcile"].firstMatch
    }

    private var logOutButton: XCUIElement {
        app.buttons["Log Out"].firstMatch
    }

    var nameTextField: XCUIElement {
        app.textFields["Your Name"].firstMatch
    }

    func whenITapSettingsButton() {
        XCTContext.runActivity(named: #function) { _ in
            settingsButton.tap()
        }
    }

    func whenITapEditButton() {
        XCTContext.runActivity(named: #function) { _ in
            editButton.tap()
        }
    }

    func whenITapDoneButton() {
        XCTContext.runActivity(named: #function) { _ in
            doneButton.tap()
        }
    }

    func whenITapLogOutButton() {
        XCTContext.runActivity(named: #function) { _ in
            logOutButton.tap()
        }
    }

    func whenIEnter(name: String) {
        XCTContext.runActivity(named: #function) { _ in
            nameTextField.clearAndTypeText(name)
        }
    }

    func thenIShouldSeeSettingsScreen() {
        XCTContext.runActivity(named: #function) { _ in
            XCTAssertTrue(settingsScreen.exists, "Settings screen does not exist")
        }
    }

    func thenIShouldSeeEditButton() {
        XCTContext.runActivity(named: #function) { _ in
            XCTAssertTrue(editButton.exists, "Edit button does not exist")
        }
    }

    func thenIShouldSeeCancelButton() {
        XCTContext.runActivity(named: #function) { _ in
            XCTAssertTrue(cancelButton.exists, "Cancel button does not exist")
        }
    }

    func thenICanReconcile() {
        XCTContext.runActivity(named: #function) { _ in
            reconcileButton.tap()
            sleep(5)
        }
    }
}
