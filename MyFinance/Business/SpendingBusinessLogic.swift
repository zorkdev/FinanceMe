struct SpendingBusinessLogic {

    private struct Constants {
        static let travelNarrative = "TfL"
    }

    private let transactionsBusinessLogic = TransactionsBusinessLogic()

    let limit: Double = {
        let regularInboundSum = ConfigManager.shared.config.regularInbound
            .flatMap({ $0.value })
            .reduce(0, +)

        let regularOutboundSum = ConfigManager.shared.config.regularOutbound
            .flatMap({ $0.value })
            .reduce(0, +)

        let inboundSum = ConfigManager.shared.config.inbound
            .flatMap({ $0.value })
            .reduce(0, +)

        let outboundSum = ConfigManager.shared.config.outbound
            .flatMap({ $0.value })
            .reduce(0, +)

        let endOfMonthBalance = ConfigManager.shared.config.endOfMonthBalance
        let carryOver = endOfMonthBalance < 0 ? endOfMonthBalance : 0

        return regularInboundSum + inboundSum - regularOutboundSum - outboundSum + carryOver
    }()

    var weeklyLimit: Double {
        return limit / Date().weeksInMonth
    }

    var dailyLimit: Double {
        return limit / Double(Date().daysInMonth)
    }

    func calculateAllowanceThisWeek() -> Promise<Double> {
        let now = Date()
        let from = now.oneMonthAgo
        let to = now.endOfWeek

        return transactionsBusinessLogic.getTransactions(from: from, to: to).then { transactions in
//            let dateString = "2018-01-21T10:27:02.335Z"
//            let date = Formatters.apiDateTime.date(from: dateString) ?? Date()
//            let transaction = Transaction(id: "123",
//                                          currency: "GBP",
//                                          amount: -1000.00,
//                                          direction: .outbound,
//                                          created: date,
//                                          narrative: "Test",
//                                          source: .masterCard,
//                                          balance: 0)
//            var transactions = transactions
//            transactions.append(transaction)

            let spending = self.calculateSpendingThisWeek(from: transactions)
            let travel = self.calculateRemainingTravelSpending(transactions: transactions,
                                                               from: from,
                                                               to: now)
            let carryOver = self.calculateCarryOverFromPreviousWeeks(from: transactions)
            let weeklyLimit = self.calculateWeeklyLimit(with: carryOver)
            let remainingAllowance = weeklyLimit - spending - travel

            return Promise(value: remainingAllowance)
        }
    }

    func calculateSpendingThisWeek(from transactions: [Transaction]) -> Double {
        let transactionsThisWeek = transactions
            .filter({ $0.created >= Date().startOfWeek &&
                      $0.created < Date().endOfWeek })

        return calculateSpending(from: transactionsThisWeek)
    }

    func calculateCarryOverFromPreviousWeeks(from transactions: [Transaction]) -> Double {
        let now = Date()
        let payday = now.next(day: ConfigManager.shared.config.payday,
                              direction: .backward)
        guard payday.isThisWeek == false else { return 0 }
        let daysSincePayday = now.numberOfDays(from: payday)

        let transactions = transactions
            .filter({ $0.created >= payday &&
                $0.created < now.startOfWeek })
        let spending = calculateSpending(from: transactions)
        let carryOver = dailyLimit * Double(daysSincePayday) - spending

        return carryOver < 0 ? carryOver : 0
    }

    func calculateWeeklyLimit(with carryOver: Double) -> Double {
        guard carryOver < 0 else { return weeklyLimit }
        let nextPayday = Date().next(day: ConfigManager.shared.config.payday,
                                     direction: .forward)
        let startOfWeek = Date().startOfWeek
        let numberOfDays = Double(nextPayday.numberOfDays(from: startOfWeek))
        let newDailyLimit = dailyLimit + (carryOver / numberOfDays)
        let newWeeklyLimit = newDailyLimit * Double(Date.daysInWeek)

        return newWeeklyLimit
    }

    func calculateSpending(from transactions: [Transaction]) -> Double {
        return abs(transactions
            .filter({ $0.source != .stripeFunding })
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
