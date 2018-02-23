public struct TodayViewModel: TodayPresentable {

    public let serviceProvider: DataServiceProvider & NetworkServiceProvider
    public let displayModel: TodayDisplayModelType
    public weak var delegate: TodayViewModelDelegate?

    public init(serviceProvider: DataServiceProvider & NetworkServiceProvider,
                delegate: TodayViewModelDelegate,
                displayModel: TodayDisplayModelType) {
        self.serviceProvider = serviceProvider
        self.delegate = delegate
        self.displayModel = displayModel
    }

}
