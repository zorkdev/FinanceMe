public struct TransactionsBusinessLogic: ServiceClient {
    public typealias ServiceProvider = NetworkServiceProvider
    public let serviceProvider: ServiceProvider

    public init(serviceProvider: ServiceProvider) {
        self.serviceProvider = serviceProvider
    }

    public func getTransactions(fromTo: FromToParameters? = nil) -> Promise<[Transaction]> {
        return serviceProvider.networkService
            .performRequest(api: API.starling(.transactions),
                            method: .get,
                            parameters: fromTo,
                            body: nil)
            .then { (halResponse: HALResponse<TransactionList>) -> Promise<[Transaction]> in
                .value(halResponse.embedded.transactions)
            }
    }
}
