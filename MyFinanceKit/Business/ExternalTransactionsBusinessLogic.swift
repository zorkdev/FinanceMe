public struct ExternalTransactionsBusinessLogic {

    public init() {}

    public func getExternalTransactions(fromTo: FromToParameters? = nil) -> Promise<[Transaction]> {
        return NetworkService.shared.performRequest(api: .zorkdev(.transactions),
                                                    method: .get,
                                                    parameters: fromTo)
    }

    public func create(transaction: Transaction) -> Promise<Transaction> {
        return NetworkService.shared.performRequest(api: .zorkdev(.transactions),
                                                    method: .post,
                                                    body: transaction)
    }

    public func delete(transaction: Transaction) -> Promise<Void> {
        guard let id = transaction.id else {
            return Promise(error: AppError.apiPathInvalid)
        }

        return NetworkService.shared.performRequest(api: .zorkdev(.transaction(id)),
                                                    method: .delete).asVoid()
    }

}
