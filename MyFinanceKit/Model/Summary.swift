import Foundation

public struct EndOfMonthSummary: Codable {

    public let balance: Double
    public let created: Date

    public init(balance: Double,
                created: Date) {
        self.balance = balance
        self.created = created
    }

}

public struct CurrentMonthSummary: Codable {

    public let allowance: Double
    public let forecast: Double

}

public struct EndOfMonthSummaryList: Codable {

    public let currentMonthSummary: CurrentMonthSummary
    public let endOfMonthSummaries: [EndOfMonthSummary]

}
