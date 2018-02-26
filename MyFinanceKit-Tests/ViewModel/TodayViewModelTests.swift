@testable import MyFinanceKit

class TodayViewModelTests: XCTestCase {

    func testInit() {
        _ = TodayViewModel(serviceProvider: MockAppState(),
                           displayModel: MockTodayDisplayModel())
    }

    func testInjection() {
        let mockDelegate = MockTodayViewModelDelegate()
        let viewModel = TodayViewModel(serviceProvider: MockAppState(),
                                       displayModel: MockTodayDisplayModel())
        viewModel.inject(delegate: mockDelegate)
        XCTAssertTrue(viewModel.delegate is MockTodayViewModelDelegate)
    }

}
