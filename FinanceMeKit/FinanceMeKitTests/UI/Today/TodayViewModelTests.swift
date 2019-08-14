import XCTest
import FinanceMeTestKit
@testable import FinanceMeKit

class TodayViewModelTests: XCTestCase {
    var businessLogic: MockUserBusinessLogic!
    var viewModel: TodayViewModel!

    override func setUp() {
        super.setUp()
        businessLogic = MockUserBusinessLogic()
        viewModel = TodayViewModel(businessLogic: businessLogic)
    }

    func testOnAppear() {
        businessLogic.getUserReturnValue = .success(())

        viewModel.onAppear()

        XCTAssertTrue(businessLogic.didCallGetUser)
    }

    func testBindings() {
        XCTAssertEqual(viewModel.allowance.value, 0)
        XCTAssertEqual(viewModel.balance.value, 0)

        businessLogic.userReturnValue = User.stub

        waitForEvent {
            XCTAssertEqual(self.viewModel.allowance.value, User.stub.allowance)
            XCTAssertEqual(self.viewModel.balance.value, User.stub.balance)
        }

        businessLogic.userReturnValue = nil

        waitForEvent {
            XCTAssertEqual(self.viewModel.allowance.value, 0)
            XCTAssertEqual(self.viewModel.balance.value, 0)
        }
    }
}
