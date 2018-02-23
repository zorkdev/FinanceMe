@testable import MyFinanceKit

class TodayViewModelTests: XCTestCase {

    func testInit() {
        _ = TodayViewModel(serviceProvider: MockAppState(),
                           delegate: MockTodayViewModelDelegate(),
                           displayModel: MockTodayDisplayModel())
    }

}
