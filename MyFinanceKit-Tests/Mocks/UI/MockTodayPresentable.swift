@testable import MyFinanceKit

class MockTodayPresentable: TodayPresentable {

    typealias ServiceProvider = NetworkServiceProvider & DataServiceProvider
    var serviceProvider: ServiceProvider

    var displayModel: TodayDisplayModelType

    //swiftlint:disable:next weak_delegate
    var delegate: TodayViewModelDelegate?

    init(serviceProvider: ServiceProvider,
         displayModel: TodayDisplayModelType,
         delegate: TodayViewModelDelegate) {
        self.serviceProvider = serviceProvider
        self.displayModel = displayModel
        self.delegate = delegate
    }

}
