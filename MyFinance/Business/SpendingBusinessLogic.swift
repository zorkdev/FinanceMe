struct SpendingBusinessLogic {

    private struct Constants {
        static let travelNarrative = "TfL"
    }

    private let transactionsBusinessLogic = TransactionsBusinessLogic()

    let limit: Double = {
        let inboundSum = ConfigManager.shared.config.inbound
            .flatMap({ $0.value })
            .reduce(0, +)

        let outboundSum = ConfigManager.shared.config.outbound
            .flatMap({ $0.value })
            .reduce(0, +)

        return inboundSum - outboundSum
    }()

    var weeklyLimit: Double {
        return limit / 4.3
    }

    func getAllowanceThisWeek() -> Promise<Double> {
        let now = Date()
        let from = now.oneMonthAgo
        let to = now.endOfWeek

        return transactionsBusinessLogic.getTransactions(from: from, to: to).then { transactions in
            let spending = self.calculateSpendingThisWeek(from: transactions)
            let travel = self.calculateRemainingTravelSpending(transactions: transactions,
                                                               from: from,
                                                               to: now)
            let remainingAllowance = self.weeklyLimit - spending - travel

            return Promise(value: remainingAllowance)
        }
    }

    func calculateSpendingThisWeek(from transactions: [Transaction]) -> Double {
        let transactionsThisWeek = transactions
            .filter({ $0.created >= Date().startOfWeek &&
                      $0.created < Date().endOfWeek })
        return calculateSpending(from: transactionsThisWeek)
    }

    func calculateSpending(from transactions: [Transaction]) -> Double {
        return abs(transactions
            .filter({ $0.direction == .outbound  })
            .flatMap({ $0.amount })
            .reduce(0, +))
    }

    func calculateRemainingTravelSpending(transactions: [Transaction],
                                          from: Date,
                                          to: Date) -> Double {
        let numberOfDays = Double(to.numberOfDays(from: from))
        let dailyTravelSpending = abs(transactions
            .filter({ $0.narrative == Constants.travelNarrative })
            .flatMap({ $0.amount })
            .reduce(0, +) / numberOfDays)

        let remainingDays = Double(to.endOfWeek.numberOfDays(from: Date()))

        return remainingDays * dailyTravelSpending
    }

}
