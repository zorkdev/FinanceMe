#if os(macOS)
    import Cocoa
    import PromiseKit
#endif

struct ExternalTransactionsBusinessLogic {

    func getExternalTransactions(from: Date? = nil,
                                 to: Date? = nil) -> Promise<[Transaction]> {
        guard let url = ZorkdevAPI.getTransactions.url else {
            return Promise(error: AppError.apiPathInvalid)
        }

        return NetworkManager.shared.performRequest(api: .zorkdev,
                                                    method: .get,
                                                    url: url).then { data in
            guard let transactions = JSONCoder.shared.decode([Transaction].self,
                                                             from: data) else {
                return Promise(error: AppError.jsonParsingError)
            }

            return Promise(value: transactions)
        }
    }

}
