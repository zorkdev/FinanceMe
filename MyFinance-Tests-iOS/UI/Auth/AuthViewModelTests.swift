//@testable import MyFinance_iOS
//
//class AuthViewModelTests: XCTestCase {
//
//    var mockLAContext = MockLAContext()
//
//    func testTryAgainButtonTapped() {
//        let newExpectation = expectation(description: "Authenticated")
//
//        let window = UIWindow(frame: CGRect.zero)
//        let mockAuthViewModelDelegate = MockAuthViewModelDelegate()
//        let viewController = UIViewController()
//        mockLAContext.canEvaluatePolicyReturnValue = true
//        mockLAContext.evaluatePolicyReturnValue = true
//
//        let authViewModel = AuthViewModel(delegate: mockAuthViewModelDelegate,
//                                          window: window,
//                                          viewController: viewController,
//                                          context: mockLAContext)
//        authViewModel.delegate = mockAuthViewModelDelegate
//        authViewModel.tryAgainButtonTapped()
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//            XCTAssertTrue(mockAuthViewModelDelegate.lastUpdateTryAgainValue == true)
//            XCTAssertTrue(mockAuthViewModelDelegate.lastUpdateLogoValue == false)
//
//            newExpectation.fulfill()
//        }
//
//        waitForExpectations(timeout: 10.0, handler: nil)
//    }
//
//    func testAuthenticate_Success() {
//        let newExpectation = expectation(description: "Authenticated")
//
//        let window = UIWindow(frame: CGRect.zero)
//        let mockAuthViewModelDelegate = MockAuthViewModelDelegate()
//        let viewController = UIViewController()
//        mockLAContext.canEvaluatePolicyReturnValue = true
//        mockLAContext.evaluatePolicyReturnValue = true
//
//        let authViewModel = AuthViewModel(delegate: mockAuthViewModelDelegate,
//                                          window: window,
//                                          viewController: viewController,
//                                          context: mockLAContext)
//        authViewModel.delegate = mockAuthViewModelDelegate
//        authViewModel.authenticate()
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//            XCTAssertTrue(mockAuthViewModelDelegate.lastUpdateTryAgainValue == true)
//            XCTAssertTrue(mockAuthViewModelDelegate.lastUpdateLogoValue == false)
//
//            newExpectation.fulfill()
//        }
//
//        waitForExpectations(timeout: 10.0, handler: nil)
//    }
//
//    func testAuthenticate_Failure() {
//        let newExpectation = expectation(description: "Authentication failed")
//
//        let window = UIWindow(frame: CGRect.zero)
//        let mockAuthViewModelDelegate = MockAuthViewModelDelegate()
//        let viewController = UIViewController()
//        mockLAContext.canEvaluatePolicyReturnValue = true
//        mockLAContext.evaluatePolicyReturnValue = false
//
//        let authViewModel = AuthViewModel(delegate: mockAuthViewModelDelegate,
//                                          window: window,
//                                          viewController: viewController,
//                                          context: mockLAContext)
//        authViewModel.delegate = mockAuthViewModelDelegate
//        authViewModel.authenticate()
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//            XCTAssertTrue(mockAuthViewModelDelegate.lastUpdateTryAgainValue == false)
//            XCTAssertTrue(mockAuthViewModelDelegate.lastUpdateLogoValue == true)
//
//            newExpectation.fulfill()
//        }
//
//        waitForExpectations(timeout: 10.0, handler: nil)
//    }
//
//}
