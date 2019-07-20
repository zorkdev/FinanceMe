public struct ExternalTransactionsBusinessLogic: ServiceClient {
    public typealias ServiceProvider = NetworkServiceProvider
    public let serviceProvider: ServiceProvider

    public init(serviceProvider: ServiceProvider) {
        self.serviceProvider = serviceProvider
    }

    public func getExternalTransactions(fromTo: FromToParameters? = nil) -> Promise<[Transaction]> {
        return serviceProvider.networkService
            .performRequest(api: API.zorkdev(.transactions),
                            method: .get,
                            parameters: fromTo,
                            body: nil)
    }

    public func create(transaction: Transaction) -> Promise<Transaction> {
        return serviceProvider.networkService
            .performRequest(api: API.zorkdev(.transactions),
                            method: .post,
                            parameters: nil,
                            body: transaction)
    }

    public func update(transaction: Transaction) -> Promise<Transaction> {
        guard let id = transaction.id else {
            return Promise(error: AppError.apiPathInvalid)
        }

        return serviceProvider.networkService
            .performRequest(api: API.zorkdev(.transaction(id)),
                            method: .put,
                            parameters: nil,
                            body: transaction)
    }

    public func delete(transaction: Transaction) -> Promise<Void> {
        guard let id = transaction.id else {
            return Promise(error: AppError.apiPathInvalid)
        }

        return serviceProvider.networkService
            .performRequest(api: API.zorkdev(.transaction(id)),
                            method: .delete,
                            parameters: nil,
                            body: nil).asVoid()
    }

    public func reconcile() -> Promise<Void> {
        return serviceProvider.networkService
            .performRequest(api: API.zorkdev(.reconcile),
                            method: .post,
                            parameters: nil,
                            body: nil).asVoid()
    }
}
