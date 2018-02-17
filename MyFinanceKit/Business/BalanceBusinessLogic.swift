public struct BalanceBusinessLogic {

    public init() {}

    public func getBalance() -> Promise<Balance> {
        return NetworkService.shared.performRequest(api: .starling(.balance),
                                                    method: .get)
            .then { (balance: Balance) -> Promise<Balance> in
                balance.save()

                return .value(balance)
        }
    }

}
