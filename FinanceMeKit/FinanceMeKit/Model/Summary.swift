struct EndOfMonthSummary: Codable, Equatable {
    let balance: Decimal
    let created: Date
}

struct CurrentMonthSummary: Codable, Equatable {
    let allowance: Decimal
    let forecast: Decimal
    let spending: Decimal
}

struct Summary: Storeable, Equatable {
    let currentMonthSummary: CurrentMonthSummary
    let endOfMonthSummaries: [EndOfMonthSummary]
}
