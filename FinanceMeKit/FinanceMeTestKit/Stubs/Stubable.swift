@testable import FinanceMeKit

public protocol Stubable {
    static var stub: Self { get }
}

extension Credentials: Stubable {
    public static var stub: Credentials { Credentials(email: "user@example.com", password: "password") }
}

extension Session: Stubable {
    public static var stub: Session { Session(token: "token") }
}

extension User: Stubable {
    public static var stub: User {
        User(name: "Name",
             payday: 10,
             startDate: ISO8601DateFormatter().date(from: "2019-01-01T00:00:00Z")!,
             largeTransaction: 10,
             allowance: 100.22,
             balance: 211.34)
    }
}

#if os(iOS) || os(macOS)
extension Transaction: Stubable {
    public static var stub: Transaction {
        Transaction(id: UUID(uuidString: "d7438025-a56b-47b8-bf62-0e4d38cd5a46")!,
                    amount: 110.42,
                    direction: .outbound,
                    created: ISO8601DateFormatter().date(from: "2019-01-01T00:00:00Z")!,
                    narrative: "Transaction",
                    source: .externalOutbound)
    }
}

extension Summary: Stubable {
    public static var stub: Summary {
        Summary(currentMonthSummary: CurrentMonthSummary(allowance: 100.34, forecast: -110.42, spending: 250.62),
                endOfMonthSummaries: [
                    EndOfMonthSummary(balance: 250.62,
                                      savings: 100.34,
                                      created: ISO8601DateFormatter().date(from: "2018-01-01T00:00:00Z")!),
                    EndOfMonthSummary(balance: 110.42,
                                      savings: 1000.22,
                                      created: ISO8601DateFormatter().date(from: "2019-02-01T00:00:00Z")!)
                ])
    }
}
#endif
