@testable import MyFinanceKit

class MockTodayPresentable: TodayPresentable {

    var networkDataServiceProvider: NetworkDataServiceProvider
    var displayModel: TodayDisplayModelType

    //swiftlint:disable:next weak_delegate
    var delegate: TodayViewModelDelegate?

    init(networkDataServiceProvider: NetworkDataServiceProvider,
         displayModel: TodayDisplayModelType,
         delegate: TodayViewModelDelegate) {
        self.networkDataServiceProvider = networkDataServiceProvider
        self.displayModel = displayModel
        self.delegate = delegate
    }

}
