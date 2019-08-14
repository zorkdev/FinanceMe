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
    public static var stub: User { User(name: "Name",
                                        payday: 10,
                                        startDate: ISO8601DateFormatter().date(from: "2019-01-01T00:00:00Z")!,
                                        largeTransaction: Decimal(string: "10")!,
                                        allowance: Decimal(string: "100.22")!,
                                        balance: Decimal(string: "211.20")!) }
}
