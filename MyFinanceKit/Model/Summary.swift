public struct EndOfMonthSummary: Storeable {

    public let balance: Double
    public let created: Date

    public init(balance: Double,
                created: Date) {
        self.balance = balance
        self.created = created
    }

}

public struct CurrentMonthSummary: Storeable {

    public let allowance: Double
    public let forecast: Double
    public let spending: Double

}

public struct EndOfMonthSummaryList: JSONCodable {

    public let currentMonthSummary: CurrentMonthSummary
    public let endOfMonthSummaries: [EndOfMonthSummary]

}
