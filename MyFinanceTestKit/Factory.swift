@testable import MyFinanceKit

struct Factory {

    static func makeSession() -> Session {
        return Session(starlingToken: "starlingToken",
                       zorkdevToken: "zorkdevToken")
    }

    static func makeUser(allowance: Double = 100.22) -> User {
        return User(name: "User Name",
                    payday: 10,
                    startDate: Date(),
                    largeTransaction: 10,
                    allowance: allowance)
    }

    static func makeBalance() -> Balance {
        return Balance(effectiveBalance: 20)
    }

    static func makeTransaction() -> Transaction {
        return Transaction(id: "id",
                           amount: 10.30,
                           direction: .inbound,
                           created: Date(),
                           narrative: "Test",
                           source: .fasterPaymentsIn)
    }

}
