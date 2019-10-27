import XCTest
import FinanceMeTestKit
@testable import FinanceMeKit

class AuthenticationViewModelTests: XCTestCase {
    var businessLogic: MockAuthenticationBusinessLogic!
    var viewModel: AuthenticationViewModel!

    override func setUp() {
        super.setUp()
        businessLogic = MockAuthenticationBusinessLogic()
        viewModel = AuthenticationViewModel(businessLogic: businessLogic)
    }

    func testOnAppear() {
        viewModel.onAppear()

        XCTAssertTrue(businessLogic.didCallAuthenticate)
    }
}
