public struct BalanceBusinessLogic: ServiceClient {
    public typealias ServiceProvider = NetworkServiceProvider & DataServiceProvider
    public let serviceProvider: ServiceProvider

    public init(serviceProvider: ServiceProvider) {
        self.serviceProvider = serviceProvider
    }

    public func getBalance() -> Promise<Balance> {
        return serviceProvider.networkService
            .performRequest(api: API.starling(.balance),
                            method: .get,
                            parameters: nil,
                            body: nil)
            .then { (balance: Balance) -> Promise<Balance> in
                balance.save(dataService: self.serviceProvider.dataService)

                return .value(balance)
            }
    }
}
