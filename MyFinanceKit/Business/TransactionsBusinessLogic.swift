public struct TransactionsBusinessLogic {

    public init() {}

    public func getTransactions(fromTo: FromToParameters? = nil) -> Promise<[Transaction]> {
        return NetworkService.shared.performRequest(api: .starling(.transactions),
                                                    method: .get,
                                                    parameters: fromTo)
            .then { (halResponse: HALResponse<TransactionList>) in
                return Promise(value: halResponse.embedded.transactions)
        }
    }

}
