import XCTest
import FinanceMeTestKit
@testable import FinanceMeKit

class LoginViewModelTests: XCTestCase {
    var businessLogic: MockSessionBusinessLogic!
    var errorViewModel: ErrorViewModel!
    var viewModel: LoginViewModel!

    override func setUp() {
        super.setUp()
        businessLogic = MockSessionBusinessLogic()
        errorViewModel = ErrorViewModel()
        viewModel = LoginViewModel(businessLogic: businessLogic,
                                   loadingState: LoadingState(),
                                   errorViewModel: errorViewModel)
    }

    func testBindings() {
        let credentials = Credentials(email: "test@test.com", password: "password")

        waitForEvent {
            XCTAssertEqual(self.viewModel.email, "")
            XCTAssertEqual(self.viewModel.password, "")
            XCTAssertTrue(self.viewModel.isDisabled)
        }

        viewModel.email = credentials.email
        viewModel.password = credentials.password

        waitForEvent {
            XCTAssertEqual(self.viewModel.email, credentials.email)
            XCTAssertEqual(self.viewModel.password, credentials.password)
            XCTAssertFalse(self.viewModel.isDisabled)
        }

        businessLogic.loginReturnValue = .success(())

        viewModel.onTap()

        waitForEvent {
            XCTAssertEqual(self.businessLogic.lastLoginParam, credentials)
        }
    }

    func testOnTap_Failure() {
        let credentials = Credentials(email: "test@test.com", password: "password")
        viewModel.email = credentials.email
        viewModel.password = credentials.password

        businessLogic.loginReturnValue = .failure(TestError())

        viewModel.onTap()

        waitForEvent {}

        XCTAssertTrue(errorViewModel.error is TestError)
    }
}
