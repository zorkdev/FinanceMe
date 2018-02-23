@testable import MyFinanceKit

class TodayViewModelTests: XCTestCase {

    func testInit() {
        _ = TodayViewModel(networkDataServiceProvider: MockNetworkDataServiceProvider(),
                           delegate: MockTodayViewModelDelegate(),
                           displayModel: MockTodayDisplayModel())
    }

}
