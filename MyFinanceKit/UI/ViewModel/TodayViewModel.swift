open class TodayViewModel: TodayPresentable {

    public let serviceProvider: ServiceProvider
    public let displayModel: TodayDisplayModelType
    public weak var delegate: TodayViewModelDelegate?

    public init(serviceProvider: ServiceProvider,
                displayModel: TodayDisplayModelType) {
        self.serviceProvider = serviceProvider
        self.displayModel = displayModel
    }

    public func inject(delegate: ViewModelDelegate) {
        guard let delegate = delegate as? TodayViewModelDelegate else { return }
        self.delegate = delegate
    }

}
