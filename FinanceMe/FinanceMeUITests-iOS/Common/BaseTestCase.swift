import XCTest

class BaseTestCase: XCTestCase {
    struct TestUser: Decodable {
        let email: String
        let password: String
    }

    let app = XCUIApplication()

    let testUser: TestUser = {
        let bundle = Bundle(for: BaseTestCase.self)
        guard let configURL = bundle.url(forResource: "TestUser", withExtension: "json"),
            let data = try? Data(contentsOf: configURL),
            let testUser = try? JSONDecoder().decode(TestUser.self, from: data) else { preconditionFailure() }
        return testUser
    }()

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
    }
}

extension BaseTestCase {
    private var loginScreen: XCUIElement {
        app.staticTexts["Login"].firstMatch
    }

    private var authenticationScreen: XCUIElement {
        app.staticTexts["Please authenticate"].firstMatch
    }

    private var homeScreen: XCUIElement {
        app.staticTexts["FinanceMe"].firstMatch
    }

    var cancelButton: XCUIElement {
        app.buttons["Cancel"].firstMatch
    }

    private var saveButton: XCUIElement {
        app.buttons["Save"].firstMatch
    }

    var loadingView: XCUIElement {
        app.staticTexts["Doing some magic... 😬"].firstMatch
    }

    private var passcodeTextField: XCUIElement {
        XCUIApplication(bundleIdentifier: "com.apple.springboard").secureTextFields["Passcode field"]
    }

    func givenIAmLoggedOut() {
        XCTContext.runActivity(named: #function) { _ in
            app.launchArguments = ["isTesting", "isLoggedOut"]
            app.launch()
            thenIShouldSeeLoginScreen()
        }
    }

    func givenIAmLoggedIn() {
        XCTContext.runActivity(named: #function) { _ in
            app.launchArguments = ["isTesting", "isLoggedIn"]
            app.launch()
            thenIShouldSeeAuthenticationScreen()
            sleep(1)
        }
    }

    func givenIAmOnHomeScreen() {
        XCTContext.runActivity(named: #function) { _ in
            givenIAmLoggedIn()
            whenIEnterPasscode()
            thenIShouldSeeHomeScreen()
        }
    }

    func whenITapCancelButton() {
        XCTContext.runActivity(named: #function) { _ in
            cancelButton.tap()
        }
    }

    func whenITapSaveButton() {
        XCTContext.runActivity(named: #function) { _ in
            saveButton.tap()
        }
    }

    func whenIEnterPasscode() {
        XCTContext.runActivity(named: #function) { _ in
            passcodeTextField.clearAndTypeText("a\r")
            sleep(1)
        }
    }

    func whenIEnterWrongPasscode() {
        XCTContext.runActivity(named: #function) { _ in
            passcodeTextField.clearAndTypeText("\r")
            sleep(1)
        }
    }

    func whenITapErrorBanner(error: String) {
        XCTContext.runActivity(named: #function) { _ in
            app.staticTexts[error].firstMatch.tap()
        }
    }

    func whenISwipeErrorBanner(error: String) {
        XCTContext.runActivity(named: #function) { _ in
            sleep(1)
            let errorBanner = app.staticTexts[error].firstMatch
            let start = errorBanner.coordinate(withNormalizedOffset: CGVector.zero)
            let finish = errorBanner.coordinate(withNormalizedOffset: CGVector(dx: .zero, dy: -15))
            start.press(forDuration: 0.01, thenDragTo: finish)
        }
    }

    func thenIShouldSeeLoginScreen() {
        XCTContext.runActivity(named: #function) { _ in
            XCTAssertTrue(loginScreen.exists, "Login screen does not exist")
        }
    }

    func thenIShouldSeeAuthenticationScreen() {
        XCTContext.runActivity(named: #function) { _ in
            XCTAssertTrue(authenticationScreen.exists, "Authentication screen does not exist")
        }
    }

    func thenIShouldSeeHomeScreen() {
        XCTContext.runActivity(named: #function) { _ in
            XCTAssertTrue(homeScreen.exists, "Home screen does not exist")
        }
    }

    func thenSaveButtonShouldBe(enabled: Bool) {
        XCTContext.runActivity(named: #function) { _ in
            XCTAssertEqual(saveButton.isEnabled, enabled, "Save button is not \(enabled ? "enabled" : "disabled")")
        }
    }

    func thenIShouldSeeErrorBanner(error: String) {
        XCTContext.runActivity(named: #function) { _ in
            XCTAssertTrue(app.staticTexts[error].firstMatch.exists, "Error banner does not exist")
        }
    }

    func thenIShouldSeeLoadingViewDisappear() {
        XCTContext.runActivity(named: #function) { _ in
            loadingView.waitForDisappearance()
        }
    }
}
