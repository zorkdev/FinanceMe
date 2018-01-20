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
            }

            if let data = data,
                let balance = try? JSONDecoder().decode(Balance.self, from: data) {
                completion(nil, balance)
            }
            completion(AppError.unknownError, nil)
        }
    }

}
