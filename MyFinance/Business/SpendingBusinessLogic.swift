class SpendingBusinessLogic {

    private struct Constants {
        static let travelNarrative = "TfL"
    }

    private let transactionsBusinessLogic = TransactionsBusinessLogic()
    private let userBusinessLogic = UserBusinessLogic()

    var user: User?

    var limit: Double {
        guard let user = user else { return 0 }
        let carryOver = user.endOfMonthBalance < 0 ? user.endOfMonthBalance : 0
        return user.spendingLimit + carryOver
    }

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

        return userBusinessLogic.getCurrentUser()
            .then { user in
                self.user = user
            }.then {
                self.transactionsBusinessLogic.getTransactions(from: from, to: to)
            }.then { transactions in
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
        guard let user = user else { return 0 }
        let now = Date()
        let payday = now.next(day: user.payday,
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
        guard let user = user else { return 0 }
        guard carryOver < 0 else { return weeklyLimit }
        let nextPayday = Date().next(day: user.payday,
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
