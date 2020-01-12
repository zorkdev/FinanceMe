struct User: Storeable, Equatable {
    let name: String
    let payday: Int
    let startDate: Date
    let largeTransaction: Double
    let allowance: Double
    let balance: Double

    init(name: String,
         payday: Int,
         startDate: Date,
         largeTransaction: Double,
         allowance: Double = 0,
         balance: Double = 0) {
        self.name = name
        self.payday = payday
        self.startDate = startDate
        self.largeTransaction = largeTransaction
        self.allowance = allowance
        self.balance = balance
    }
}
