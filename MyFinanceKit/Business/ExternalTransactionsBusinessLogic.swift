public struct ExternalTransactionsBusinessLogic {

    public init() {}

    public func getExternalTransactions(from: Date? = nil,
                                        to: Date? = nil) -> Promise<[Transaction]> {
        guard let url = ZorkdevAPI.transactions.url else {
            return Promise(error: AppError.apiPathInvalid)
        }

        return NetworkManager.shared.performRequest(api: .zorkdev,
                                                    method: .get,
                                                    url: url)
            .then { data in
                guard let transactions = [Transaction](data: data) else {
                    return Promise(error: AppError.jsonParsingError)
                }

                return Promise(value: transactions)
        }
    }

    public func create(transaction: Transaction) -> Promise<Transaction> {
        guard let url = ZorkdevAPI.transactions.url else {
            return Promise(error: AppError.apiPathInvalid)
        }

        let body = transaction.encoded()

        return NetworkManager.shared.performRequest(api: .zorkdev,
                                                    method: .post,
                                                    url: url,
                                                    body: body)
            .then { data in
                guard let transaction = Transaction(data: data) else {
                    return Promise(error: AppError.jsonParsingError)
                }

                return Promise(value: transaction)
        }
    }

    public func delete(transaction: Transaction) -> Promise<Void> {
        guard let id = transaction.id,
            let url = ZorkdevAPI.transaction(id).url else {
                return Promise(error: AppError.apiPathInvalid)
        }

        return NetworkManager.shared.performRequest(api: .zorkdev,
                                                    method: .delete,
                                                    url: url).asVoid()
    }

}
