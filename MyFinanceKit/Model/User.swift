public struct User: Storeable {

    public let name: String
    public let payday: Int
    public let startDate: Date
    public let largeTransaction: Double
    public let allowance: Double

    public init(name: String,
                payday: Int,
                startDate: Date,
                largeTransaction: Double,
                allowance: Double = 0) {
        self.name = name
        self.payday = payday
        self.startDate = startDate
        self.largeTransaction = largeTransaction
        self.allowance = allowance
    }

}
