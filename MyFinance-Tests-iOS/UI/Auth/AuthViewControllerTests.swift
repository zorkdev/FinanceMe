@testable import MyFinance_iOS

class AuthViewControllerTests: XCTestCase {

    var mockAuthViewModel = MockAuthViewModel()

    override func setUp() {
        super.setUp()

        mockAuthViewModel = MockAuthViewModel()
    }

    func testTryAgainButtonTapped() {
        let authViewController = AuthViewController()
        authViewController.viewModel = mockAuthViewModel
        mockAuthViewModel.delegate = authViewController

        authViewController.tryAgainButtonTapped(UIButton())

        XCTAssertTrue(mockAuthViewModel.didCallTryAgainButtonTapped)
    }

    func testUpdate() {
        let authViewController = AuthViewController.instantiate()
        authViewController.viewModel = mockAuthViewModel
        mockAuthViewModel.delegate = authViewController
        _ = authViewController.view

        let newExpectation = expectation(description: "Animation finished")

        mockAuthViewModel.delegate?.updateLogo(isHidden: false)
        mockAuthViewModel.delegate?.updateLogo(isHidden: true)
        mockAuthViewModel.delegate?.updateTryAgain(isHidden: false)
        mockAuthViewModel.delegate?.updateTryAgain(isHidden: true)

        DispatchQueue.main.asyncAfter(deadline: .now() + AuthDisplayModel.animationDuration) {
            newExpectation.fulfill()
        }

        waitForExpectations(timeout: 10.0, handler: nil)
    }

}
