import Combine

public protocol BalanceBusinessLogicType {
    func getBalance() -> AnyPublisher<Balance, Error>
}

public struct BalanceBusinessLogic: BalanceBusinessLogicType, ServiceClient {
    public let serviceProvider: NetworkServiceProvider & DataServiceProvider

    public init(serviceProvider: ServiceProvider) {
        self.serviceProvider = serviceProvider
    }

    public func getBalance() -> AnyPublisher<Balance, Error> {
        serviceProvider.networkService
            .perform(api: StarlingAPI.balance,
                     method: .get,
                     body: nil)
            .map { (balance: Balance) in
                balance.save(dataService: self.serviceProvider.dataService)
                return balance
            }.eraseToAnyPublisher()
    }
}
