import Foundation

class SpendingBusinessLogic {

    private let transactionsBusinessLogic = TransactionsBusinessLogic()

    func getSpendingThisWeek(completion: @escaping (Error?, Double?) -> Void) {
        transactionsBusinessLogic.getTransactions(from: Date().startOfWeek,
                                                  to: Date().endOfWeek) { error, transactions in
            if let error = error {
                completion(error, nil)
                return
            }

            guard let transactions = transactions else {
                completion(AppError.unknownError, nil)
                return
            }

            let spending = -transactions
                .filter({ $0.amount < 0 })
                .flatMap({ $0.amount })
                .reduce(0, +)

            completion(nil, spending)
        }
    }

}
