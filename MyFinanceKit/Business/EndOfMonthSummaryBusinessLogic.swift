public struct EndOfMonthSummaryBusinessLogic {

    private let networkService: NetworkServiceType

    public init(networkService: NetworkServiceType) {
        self.networkService = networkService
    }

    public func getEndOfMonthSummaryList() -> Promise<EndOfMonthSummaryList> {
        return networkService.performRequest(api: API.zorkdev(.endOfMonthSummaries),
                                             method: .get,
                                             parameters: nil,
                                             body: nil)
    }

}
