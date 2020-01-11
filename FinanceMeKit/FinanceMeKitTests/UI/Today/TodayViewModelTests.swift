import XCTest
import FinanceMeTestKit
@testable import FinanceMeKit

final class TodayViewModelTests: XCTestCase {
    var businessLogic: MockUserBusinessLogic!
    var viewModel: TodayViewModel!

    override func setUp() {
        super.setUp()
        businessLogic = MockUserBusinessLogic()
        viewModel = TodayViewModel(businessLogic: businessLogic)
    }

    func testOnAppear() {
        viewModel.onAppear()

        XCTAssertTrue(businessLogic.didCallFetchUser)
    }

    func testBindings() {
        XCTAssertEqual(viewModel.allowance.value, 0)
        XCTAssertEqual(viewModel.balance.value, 0)
        XCTAssertEqual(viewModel.icon, "")

        businessLogic.userReturnValue = User.stub

        waitForEvent {
            XCTAssertEqual(self.viewModel.allowance.value, User.stub.allowance)
            XCTAssertEqual(self.viewModel.balance.value, User.stub.balance)
            XCTAssertEqual(self.viewModel.icon, "😇")
        }
    }
}
