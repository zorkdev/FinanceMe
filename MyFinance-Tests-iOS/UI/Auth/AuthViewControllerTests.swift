@testable import MyFinance_iOS

class AuthViewControllerTests: XCTestCase {

    var mockAuthViewModel: MockAuthViewModel!
    var authViewController: AuthViewController!

    override func setUp() {
        super.setUp()

        mockAuthViewModel = MockAuthViewModel()
        authViewController = AuthViewController.instantiate()
        authViewController.inject(viewModel: mockAuthViewModel)
        mockAuthViewModel.delegate = authViewController
        _ = authViewController.view
    }

    func testStatusBarStyle() {
        XCTAssertTrue(authViewController.preferredStatusBarStyle == .lightContent)
    }

    func testTryAgainButtonTapped() {
        authViewController.tryAgainButtonTapped(UIButton())

        XCTAssertTrue(mockAuthViewModel.didCallTryAgainButtonTapped)
    }

    func testUpdateLogoHidden() {
        let newExpectation = expectation(description: "Animation finished")

        authViewController.updateLogo(isHidden: true)

        DispatchQueue.main.asyncAfter(deadline: .now() + AuthDisplayModel.animationDuration) {
            XCTAssertTrue(self.authViewController.logoImageView.isHidden)
            XCTAssertEqual(self.authViewController.logoImageView.alpha, AuthDisplayModel.minAlpha)
            newExpectation.fulfill()
        }

        waitForExpectations(timeout: 10.0, handler: nil)
    }

    func testUpdateLogoVisible() {
        let newExpectation = expectation(description: "Animation finished")

        authViewController.updateLogo(isHidden: false)

        DispatchQueue.main.asyncAfter(deadline: .now() + AuthDisplayModel.animationDuration) {
            XCTAssertFalse(self.authViewController.logoImageView.isHidden)
            XCTAssertEqual(self.authViewController.logoImageView.alpha, AuthDisplayModel.maxAlpha)
            newExpectation.fulfill()
        }

        waitForExpectations(timeout: 10.0, handler: nil)
    }

    func testUpdateTryAgainHidden() {
        let newExpectation = expectation(description: "Animation finished")

        authViewController.updateTryAgain(isHidden: true)

        DispatchQueue.main.asyncAfter(deadline: .now() + AuthDisplayModel.animationDuration) {
            XCTAssertTrue(self.authViewController.tryAgainView.isHidden)
            XCTAssertEqual(self.authViewController.tryAgainView.alpha, AuthDisplayModel.minAlpha)
            newExpectation.fulfill()
        }

        waitForExpectations(timeout: 10.0, handler: nil)
    }

    func testUpdateTryAgainVisible() {
        let newExpectation = expectation(description: "Animation finished")

        authViewController.updateTryAgain(isHidden: false)

        DispatchQueue.main.asyncAfter(deadline: .now() + AuthDisplayModel.animationDuration) {
            XCTAssertFalse(self.authViewController.tryAgainView.isHidden)
            XCTAssertEqual(self.authViewController.tryAgainView.alpha, AuthDisplayModel.maxAlpha)
            newExpectation.fulfill()
        }

        waitForExpectations(timeout: 10.0, handler: nil)
    }

    func testInject() {
        XCTAssertTrue(authViewController.viewModel is MockAuthViewModel)
    }

}
