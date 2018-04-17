public struct EndOfMonthSummaryBusinessLogic: ServiceClient {

    public typealias ServiceProvider = NetworkServiceProvider
    public let serviceProvider: ServiceProvider

    public init(serviceProvider: ServiceProvider) {
        self.serviceProvider = serviceProvider
    }

    public func getEndOfMonthSummaryList() -> Promise<EndOfMonthSummaryList> {
        return serviceProvider.networkService
            .performRequest(api: API.zorkdev(.endOfMonthSummaries),
                            method: .get,
                            parameters: nil,
                            body: nil)
    }

}
