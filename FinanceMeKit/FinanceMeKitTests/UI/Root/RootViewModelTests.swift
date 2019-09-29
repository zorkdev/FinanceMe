import XCTest
import FinanceMeTestKit
@testable import FinanceMeKit

class RootViewModelTests: XCTestCase {
    var businessLogic: MockSessionBusinessLogic!
    var viewModel: RootViewModel!

    override func setUp() {
        super.setUp()
        businessLogic = MockSessionBusinessLogic()
        viewModel = RootViewModel(businessLogic: businessLogic)
    }

    func testBindings() {
        waitForEvent {
            XCTAssertFalse(self.viewModel.isLoggedIn)
        }

        businessLogic.isLoggedInReturnValue = true

        waitForEvent {
            XCTAssertTrue(self.viewModel.isLoggedIn)
        }
    }
}
