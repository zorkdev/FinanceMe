public struct EndOfMonthSummary: Storeable, Equatable {

    public let balance: Double
    public let created: Date

    public init(balance: Double,
                created: Date) {
        self.balance = balance
        self.created = created
    }

}

public struct CurrentMonthSummary: Storeable, Equatable {

    public let allowance: Double
    public let forecast: Double
    public let spending: Double

}

public struct EndOfMonthSummaryList: JSONCodable, Equatable {

    public let currentMonthSummary: CurrentMonthSummary
    public let endOfMonthSummaries: [EndOfMonthSummary]

    public init(currentMonthSummary: CurrentMonthSummary, endOfMonthSummaries: [EndOfMonthSummary]) {
        self.currentMonthSummary = currentMonthSummary
        self.endOfMonthSummaries = endOfMonthSummaries
    }

}
