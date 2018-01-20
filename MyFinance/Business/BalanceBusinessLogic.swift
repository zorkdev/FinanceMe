import Foundation

class BalanceBusinessLogic {

    func getBalance(completion: @escaping (Error?, Balance?) -> Void) {
        guard let url = StarlingAPI.getBalance.url else {
            completion(AppError.apiPathInvalid, nil)
            return
        }

        NetworkManager.shared.performRequest(method: .get, url: url) { error, data in
            if let error = error {
                completion(error, nil)
                return
            }

            guard let data = data,
                let balance = JSONCoder.shared.decode(Balance.self, from: data) else {
                completion(AppError.unknownError, nil)
                return
            }

            completion(nil, balance)
        }
    }

}
