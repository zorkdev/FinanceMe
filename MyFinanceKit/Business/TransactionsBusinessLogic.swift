public struct TransactionsBusinessLogic {

    public init() {}

    public func getTransactions(fromTo: FromToParameters? = nil) -> Promise<[Transaction]> {
        return NetworkService.shared.performRequest(api: API.starling(.transactions),
                                                    method: .get,
                                                    parameters: fromTo)
            .then { (halResponse: HALResponse<TransactionList>) -> Promise<[Transaction]> in
                return .value(halResponse.embedded.transactions)
        }
    }

}
