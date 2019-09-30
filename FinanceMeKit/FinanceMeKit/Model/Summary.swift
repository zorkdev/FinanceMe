public struct EndOfMonthSummary: Codable, Equatable {
    public let balance: Decimal
    public let created: Date
}

public struct CurrentMonthSummary: Codable, Equatable {
    public let allowance: Decimal
    public let forecast: Decimal
    public let spending: Decimal
}

public struct Summary: Storeable, Equatable {
    public let currentMonthSummary: CurrentMonthSummary
    public let endOfMonthSummaries: [EndOfMonthSummary]
}
