public struct TransactionsBusinessLogic {

    public init() {}

    public func getTransactions(from: Date? = nil,
                                to: Date? = nil) -> Promise<[Transaction]> {
        guard let url = StarlingAPI.transactions.url else {
            return Promise(error: AppError.apiPathInvalid)
        }

        var parameters = JSON()

        if let from = from {
            parameters[StarlingParameters.from.rawValue] = Formatters.apiDate.string(from: from)
        }

        if let to = to {
            parameters[StarlingParameters.to.rawValue] = Formatters.apiDate.string(from: to)
        }

        return NetworkManager.shared.performRequest(api: .starling,
                                                    method: .get,
                                                    url: url,
                                                    parameters: parameters)
            .then { data in
                guard let halResponse = HALResponse<TransactionList>(data: data) else {
                    return Promise(error: AppError.jsonParsingError)
                }

                return Promise(value: halResponse.embedded.transactions)
        }
    }

}
