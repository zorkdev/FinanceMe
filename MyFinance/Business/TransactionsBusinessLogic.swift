class TransactionsBusinessLogic {

    func getTransactions(from: Date? = nil,
                         to: Date? = nil) -> Promise<[Transaction]> {
        guard let url = StarlingAPI.getTransactions.url else {
            return Promise(error: AppError.apiPathInvalid)
        }

        var parameters = JSON()

        if let from = from {
            parameters[StarlingParameters.from.rawValue] = Formatters.apiDate.string(from: from)
        }

        if let to = to {
            parameters[StarlingParameters.to.rawValue] = Formatters.apiDate.string(from: to)
        }

        return NetworkManager.shared.performRequest(method: .get,
                                                    url: url,
                                                    parameters: parameters).then { data in
            guard let halResponse = JSONCoder.shared.decode(HALResponse<TransactionList>.self,
                                                            from: data) else {
                return Promise(error: AppError.jsonParsingError)
            }

            return Promise(value: halResponse.embedded.transactions)
        }
    }

}
