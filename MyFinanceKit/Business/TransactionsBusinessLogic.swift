public struct TransactionsBusinessLogic {

    private let networkService: NetworkServiceType

    public init(networkService: NetworkServiceType) {
        self.networkService = networkService
    }

    public func getTransactions(fromTo: FromToParameters? = nil) -> Promise<[Transaction]> {
        return networkService.performRequest(api: API.starling(.transactions),
                                             method: .get,
                                             parameters: fromTo,
                                             body: nil)
            .then { (halResponse: HALResponse<TransactionList>) -> Promise<[Transaction]> in
                return .value(halResponse.embedded.transactions)
        }
    }

}
