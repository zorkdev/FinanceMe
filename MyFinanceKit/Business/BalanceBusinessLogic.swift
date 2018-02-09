public struct BalanceBusinessLogic {

    public init() {}

    public func getBalance() -> Promise<Balance> {
        return NetworkService.shared.performRequest(api: .starling(.balance),
                                                    method: .get)
            .then { (balance: Balance) in
                balance.save()

                return Promise(value: balance)
        }
    }

}
