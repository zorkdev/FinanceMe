struct EndOfMonthSummary: Codable, Equatable {
    let balance: Double
    let savings: Double
    let created: Date
}

struct CurrentMonthSummary: Codable, Equatable {
    let allowance: Double
    let forecast: Double
    let spending: Double
}

struct Summary: Storeable, Equatable {
    let currentMonthSummary: CurrentMonthSummary
    let endOfMonthSummaries: [EndOfMonthSummary]
}
