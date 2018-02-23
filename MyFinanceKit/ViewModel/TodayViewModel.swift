public struct TodayViewModel: TodayPresentable {

    public let serviceProvider: ServiceProvider
    public let displayModel: TodayDisplayModelType
    public weak var delegate: TodayViewModelDelegate?

    public init(serviceProvider: ServiceProvider,
                delegate: TodayViewModelDelegate,
                displayModel: TodayDisplayModelType) {
        self.serviceProvider = serviceProvider
        self.delegate = delegate
        self.displayModel = displayModel
    }

}
