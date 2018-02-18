public struct BalanceBusinessLogic {

    private let networkService: NetworkServiceType
    private let dataService: DataService

    public init(networkService: NetworkServiceType,
                dataService: DataService) {
        self.networkService = networkService
        self.dataService = dataService
    }

    public func getBalance() -> Promise<Balance> {
        return networkService.performRequest(api: API.starling(.balance),
                                             method: .get,
                                             parameters: nil,
                                             body: nil)
            .then { (balance: Balance) -> Promise<Balance> in
                balance.save(dataService: self.dataService)

                return .value(balance)
        }
    }

}
