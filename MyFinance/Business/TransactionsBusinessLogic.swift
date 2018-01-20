import Foundation

class TransactionsBusinessLogic {

    struct Constants {
        static let fromKey = "from"
        static let toKey = "to"
    }

    func getTransactions(from: Date? = nil,
                         to: Date? = nil,
                         completion: @escaping (Error?, [Transaction]?) -> Void) {
        guard let url = StarlingAPI.getTransactions.url else {
            completion(AppError.apiPathInvalid, nil)
            return
        }

        var parameters = JSON()

        if let from = from {
            parameters[Constants.fromKey] = Formatters.apiDate.string(from: from)
        }

        if let to = to {
            parameters[Constants.toKey] = Formatters.apiDate.string(from: to)
        }

        NetworkManager.shared.performRequest(method: .get,
                                             url: url,
                                             parameters: parameters) { error, data in
            if let error = error {
                completion(error, nil)
                return
            }

            guard let data = data,
                let halResponse = JSONCoder.shared.decode(HALResponse<TransactionList>.self, from: data) else {
                completion(AppError.unknownError, nil)
                return
            }
            
            completion(nil, halResponse.embedded.transactions)
        }
    }

}
