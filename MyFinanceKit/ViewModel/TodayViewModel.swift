public struct TodayViewModel: TodayPresentable {

    public let displayModel: TodayDisplayModelType
    public weak var delegate: TodayViewModelDelegate?

    public init(delegate: TodayViewModelDelegate, displayModel: TodayDisplayModelType) {
        self.delegate = delegate
        self.displayModel = displayModel
    }

}
