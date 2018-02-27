@testable import MyFinance_iOS

class AuthViewModelTests: XCTestCase {

    var mockAppStateiOS = MockAppStateiOS()
    var mockNavigator: MockNavigator!
    var mockLAContext: MockLAContext!

    override func setUp() {
        super.setUp()

        mockAppStateiOS = MockAppStateiOS()
        mockNavigator = mockAppStateiOS.navigator as? MockNavigator
        mockLAContext = mockAppStateiOS.laContext as? MockLAContext
    }

    func testTryAgainButtonTapped() {
        let newExpectation = expectation(description: "Authenticated")

        let mockAuthViewModelDelegate = MockAuthViewModelDelegate()
        mockLAContext.canEvaluatePolicyReturnValue = true
        mockLAContext.evaluatePolicyReturnValue = true

        let authViewModel = AuthViewModel(serviceProvider: mockAppStateiOS)
        authViewModel.inject(delegate: mockAuthViewModelDelegate)
        authViewModel.tryAgainButtonTapped()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertTrue(mockAuthViewModelDelegate.lastUpdateTryAgainValue == true)
            XCTAssertTrue(mockAuthViewModelDelegate.lastUpdateLogoValue == false)
            XCTAssertTrue(self.mockNavigator.didCallHideAuthWindow)

            newExpectation.fulfill()
        }

        waitForExpectations(timeout: 10.0, handler: nil)
    }

    func testAuthenticate_Success() {
        let newExpectation = expectation(description: "Authenticated")

        let mockAuthViewModelDelegate = MockAuthViewModelDelegate()
        mockLAContext.canEvaluatePolicyReturnValue = true
        mockLAContext.evaluatePolicyReturnValue = true

        let authViewModel = AuthViewModel(serviceProvider: mockAppStateiOS)
        authViewModel.delegate = mockAuthViewModelDelegate
        authViewModel.authenticate()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertTrue(mockAuthViewModelDelegate.lastUpdateTryAgainValue == true)
            XCTAssertTrue(mockAuthViewModelDelegate.lastUpdateLogoValue == false)
            XCTAssertTrue(self.mockNavigator.didCallHideAuthWindow)

            newExpectation.fulfill()
        }

        waitForExpectations(timeout: 10.0, handler: nil)
    }

    func testAuthenticate_Failure() {
        let newExpectation = expectation(description: "Authentication failed")

        let mockAuthViewModelDelegate = MockAuthViewModelDelegate()
        mockLAContext.canEvaluatePolicyReturnValue = true
        mockLAContext.evaluatePolicyReturnValue = false

        let authViewModel = AuthViewModel(serviceProvider: mockAppStateiOS)
        authViewModel.delegate = mockAuthViewModelDelegate
        authViewModel.authenticate()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertTrue(mockAuthViewModelDelegate.lastUpdateTryAgainValue == false)
            XCTAssertTrue(mockAuthViewModelDelegate.lastUpdateLogoValue == true)
            XCTAssertFalse(self.mockNavigator.didCallHideAuthWindow)

            newExpectation.fulfill()
        }

        waitForExpectations(timeout: 10.0, handler: nil)
    }

    func testAddOcclusion() {
        let authViewModel = AuthViewModel(serviceProvider: mockAppStateiOS)
        authViewModel.addOcclusion()
        XCTAssertTrue(mockNavigator.didCallShowAuthWindow)
    }

}
