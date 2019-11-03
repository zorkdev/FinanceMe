struct User: Storeable, Equatable {
    let name: String
    let payday: Int
    let startDate: Date
    let largeTransaction: Decimal
    let allowance: Decimal
    let balance: Decimal

    init(name: String,
         payday: Int,
         startDate: Date,
         largeTransaction: Decimal,
         allowance: Decimal = 0,
         balance: Decimal = 0) {
        self.name = name
        self.payday = payday
        self.startDate = startDate
        self.largeTransaction = largeTransaction
        self.allowance = allowance
        self.balance = balance
    }
}
