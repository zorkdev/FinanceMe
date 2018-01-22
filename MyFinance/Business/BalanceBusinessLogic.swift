struct BalanceBusinessLogic {

    func getBalance() -> Promise<Balance> {
        guard let url = StarlingAPI.getBalance.url else {
            return Promise(error: AppError.apiPathInvalid)
        }

        return NetworkManager.shared.performRequest(api: .starling,
                                                    method: .get,
                                                    url: url).then { data in
            guard let balance = JSONCoder.shared.decode(Balance.self, from: data) else {
                return Promise(error: AppError.jsonParsingError)
            }

            return Promise(value: balance)
        }
    }

}
