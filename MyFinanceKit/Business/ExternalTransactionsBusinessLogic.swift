public struct ExternalTransactionsBusinessLogic {

    private let networkService: NetworkServiceType

    public init(networkService: NetworkServiceType) {
        self.networkService = networkService
    }

    public func getExternalTransactions(fromTo: FromToParameters? = nil) -> Promise<[Transaction]> {
        return networkService.performRequest(api: API.zorkdev(.transactions),
                                             method: .get,
                                             parameters: fromTo,
                                             body: nil)
    }

    public func create(transaction: Transaction) -> Promise<Transaction> {
        return networkService.performRequest(api: API.zorkdev(.transactions),
                                             method: .post,
                                             parameters: nil,
                                             body: transaction)
    }

    public func delete(transaction: Transaction) -> Promise<Void> {
        guard let id = transaction.id else {
            return Promise(error: AppError.apiPathInvalid)
        }

        return networkService.performRequest(api: API.zorkdev(.transaction(id)),
                                             method: .delete,
                                             parameters: nil,
                                             body: nil).asVoid()
    }

}
