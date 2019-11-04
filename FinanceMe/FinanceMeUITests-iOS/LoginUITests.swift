import XCTest

class LoginUITests: BaseTestCase, Login {
    func testLoginJourney() {
        givenIAmLoggedOut()
        thenLoginButtonShouldBe(enabled: false)

        whenIEnter(email: "invalid@email.com")
        whenIEnter(password: "wrong")
        thenLoginButtonShouldBe(enabled: true)

        whenITapLoginButton()
        thenIShouldSeeLoadingViewDisappear()
        thenIShouldSeeErrorBanner(error: "Internal Server Error (500)")

        whenITapErrorBanner(error: "Internal Server Error (500)")
        whenITapLoginButton()
        thenIShouldSeeLoadingViewDisappear()
        thenIShouldSeeErrorBanner(error: "Internal Server Error (500)")

        whenISwipeErrorBanner(error: "Internal Server Error (500)")
        whenIEnter(email: testUser.email)
        whenIEnter(password: testUser.password)
        whenITapLoginButton()
        thenIShouldSeeLoadingViewDisappear()
        thenIShouldSeeAuthenticationScreen()

        whenIEnterWrongPasscode()
        whenITapAuthenticateButton()
        whenIEnterPasscode()
        thenIShouldSeeHomeScreen()
    }
}

protocol Login {}

extension Login where Self: BaseTestCase {
    private var emailTextField: XCUIElement {
        app.textFields["Email"].firstMatch
    }

    private var passwordTextField: XCUIElement {
        app.secureTextFields["Password"].firstMatch
    }

    private var loginButton: XCUIElement {
        app.buttons["Log In"].firstMatch
    }

    private var authenticateButton: XCUIElement {
        app.buttons["Authenticate"].firstMatch
    }

    func whenIEnter(email: String) {
        XCTContext.runActivity(named: #function) { _ in
            emailTextField.clearAndTypeText(email)
        }
    }

    func whenIEnter(password: String) {
        XCTContext.runActivity(named: #function) { _ in
            passwordTextField.clearAndTypeText(password)
        }
    }

    func whenITapLoginButton() {
        XCTContext.runActivity(named: #function) { _ in
            loginButton.tap()
        }
    }

    func whenITapAuthenticateButton() {
        XCTContext.runActivity(named: #function) { _ in
            authenticateButton.tap()
        }
    }

    func thenLoginButtonShouldBe(enabled: Bool) {
        XCTContext.runActivity(named: #function) { _ in
            XCTAssertEqual(loginButton.isEnabled, enabled, "Login button is not \(enabled ? "enabled" : "disabled")")
        }
    }
}
