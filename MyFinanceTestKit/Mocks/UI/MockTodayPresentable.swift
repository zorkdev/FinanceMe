import MyFinanceKit

class MockTodayPresentable: TodayPresentable {

    typealias ServiceProvider = NetworkServiceProvider & DataServiceProvider
    var serviceProvider: ServiceProvider

    var displayModel: TodayDisplayModelType

    weak var delegate: TodayViewModelDelegate?

    init(serviceProvider: ServiceProvider,
         displayModel: TodayDisplayModelType,
         delegate: TodayViewModelDelegate) {
        self.serviceProvider = serviceProvider
        self.displayModel = displayModel
        self.delegate = delegate
    }

    func inject(delegate: ViewModelDelegate) {}

}
