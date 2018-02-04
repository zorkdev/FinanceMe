import PromiseKit

public struct BalanceBusinessLogic {

    public init() {}

    public func getBalance() -> Promise<Balance> {
        guard let url = StarlingAPI.balance.url else {
            return Promise(error: AppError.apiPathInvalid)
        }

        return NetworkManager.shared.performRequest(api: .starling,
                                                    method: .get,
                                                    url: url)
            .then { data in
                guard let balance = JSONCoder.shared.decode(Balance.self, from: data) else {
                    return Promise(error: AppError.jsonParsingError)
                }

                DataManager.shared.balance = balance.effectiveBalance

                return Promise(value: balance)
        }
    }

}
