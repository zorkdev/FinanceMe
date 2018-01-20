class SpendingBusinessLogic {

    private let transactionsBusinessLogic = TransactionsBusinessLogic()

    func getSpendingThisWeek() -> Promise<Double> {
        return transactionsBusinessLogic.getTransactions(from: Date().startOfWeek,
                                                         to: Date().endOfWeek).then { transactions in
            let spending = -transactions
                .filter({ $0.amount < 0 })
                .flatMap({ $0.amount })
                .reduce(0, +)

            return Promise(value: spending)
        }
    }

}
