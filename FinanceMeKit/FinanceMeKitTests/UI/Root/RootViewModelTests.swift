import XCTest
import FinanceMeTestKit
@testable import FinanceMeKit

final class RootViewModelTests: XCTestCase {
    var service: MockSessionService!
    var businessLogic: MockSessionBusinessLogic!
    var viewModel: RootViewModel!

    override func setUp() {
        super.setUp()
        service = MockSessionService()
        businessLogic = MockSessionBusinessLogic()
        viewModel = RootViewModel(service: service, businessLogic: businessLogic)
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
