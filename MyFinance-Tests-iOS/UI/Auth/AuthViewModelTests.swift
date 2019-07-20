import LocalAuthentication
@testable import MyFinance_iOS

class AuthViewModelTests: ServiceClientiOSTestCase {
    func testTryAgainButtonTapped() {
        let newExpectation = expectation(description: "Authenticated")

        let mockAuthViewModelDelegate = MockAuthViewModelDelegate()
        mockAppState.mockLAContext.canEvaluatePolicyReturnValue = true
        mockAppState.mockLAContext.evaluatePolicyReturnValue = true

        let authViewModel = AuthViewModel(serviceProvider: mockAppState)
        authViewModel.inject(delegate: mockAuthViewModelDelegate)
        authViewModel.tryAgainButtonTapped()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertTrue(mockAuthViewModelDelegate.lastUpdateTryAgainValue == true)
            XCTAssertTrue(mockAuthViewModelDelegate.lastUpdateLogoValue == false)
            XCTAssertTrue(self.mockAppState.mockNavigator.didCallHideAuthWindow)

            newExpectation.fulfill()
        }

        waitForExpectations(timeout: 10.0, handler: nil)
    }

    func testAuthenticate_Success() {
        let newExpectation = expectation(description: "Authenticated")

        let mockAuthViewModelDelegate = MockAuthViewModelDelegate()
        mockAppState.mockLAContext.canEvaluatePolicyReturnValue = true
        mockAppState.mockLAContext.evaluatePolicyReturnValue = true
        mockAppState.mockSessionService.hasSessionReturnValue = true

        let authViewModel = AuthViewModel(serviceProvider: mockAppState)
        authViewModel.delegate = mockAuthViewModelDelegate
        authViewModel.authenticate()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertTrue(mockAuthViewModelDelegate.lastUpdateTryAgainValue == true)
            XCTAssertTrue(mockAuthViewModelDelegate.lastUpdateLogoValue == false)
            XCTAssertTrue(self.mockAppState.mockNavigator.didCallShowAuthWindow)
            XCTAssertTrue(self.mockAppState.mockNavigator.didCallHideAuthWindow)

            newExpectation.fulfill()
        }

        waitForExpectations(timeout: 10.0, handler: nil)
    }

    func testAuthenticate_Failure() {
        let newExpectation = expectation(description: "Authentication failed")

        let mockAuthViewModelDelegate = MockAuthViewModelDelegate()
        mockAppState.mockLAContext.createCanEvaluatePolicyReturnValue = true
        mockAppState.mockLAContext.createEvaluatePolicyReturnValue = false
        mockAppState.mockSessionService.hasSessionReturnValue = true

        let authViewModel = AuthViewModel(serviceProvider: mockAppState)
        authViewModel.delegate = mockAuthViewModelDelegate
        authViewModel.authenticate()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertTrue(mockAuthViewModelDelegate.lastUpdateTryAgainValue == false)
            XCTAssertTrue(mockAuthViewModelDelegate.lastUpdateLogoValue == true)
            XCTAssertTrue(self.mockAppState.mockNavigator.didCallShowAuthWindow)
            XCTAssertFalse(self.mockAppState.mockNavigator.didCallHideAuthWindow)

            newExpectation.fulfill()
        }

        waitForExpectations(timeout: 10.0, handler: nil)
    }

    func testAddOcclusion() {
        mockAppState.mockSessionService.hasSessionReturnValue = true
        let authViewModel = AuthViewModel(serviceProvider: mockAppState)
        authViewModel.addOcclusion()
        XCTAssertTrue(mockAppState.mockNavigator.didCallShowAuthWindow)
    }

    func testCreateLAContext() {
        _ = LAContext().createContext()
    }
}
