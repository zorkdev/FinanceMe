public struct TodayViewModel: TodayPresentable {

    public let networkDataServiceProvider: NetworkDataServiceProvider
    public let displayModel: TodayDisplayModelType
    public weak var delegate: TodayViewModelDelegate?

    public init(networkDataServiceProvider: NetworkDataServiceProvider,
                delegate: TodayViewModelDelegate,
                displayModel: TodayDisplayModelType) {
        self.networkDataServiceProvider = networkDataServiceProvider
        self.delegate = delegate
        self.displayModel = displayModel
    }

}
