public class DataManager {

    private struct Constants {
        static let balanceKey = "balance"
        static let allowanceKey = "allowance"
        static let transactionsKey = "transactions"
        static let endOfMonthSummariesKey = "endOfMonthSummaries"
    }

    public static let shared = DataManager()

    public var balance: Double {
        get {
            return KeychainWrapper.standard.double(forKey: Constants.balanceKey) ?? 0
        }
        set {
            KeychainWrapper.standard.set(newValue, forKey: Constants.balanceKey)
        }
    }

    public var allowance: Double {
        get {
            return KeychainWrapper.standard.double(forKey: Constants.allowanceKey) ?? 0
        }
        set {
            KeychainWrapper.standard.set(newValue, forKey: Constants.allowanceKey)
        }
    }

    public var transactions: [Transaction] {
        get {
            guard let data = KeychainWrapper.standard.data(forKey: Constants.transactionsKey),
                let transactions = JSONCoder.shared.decode([Transaction].self, from: data) else {
                    return []
            }
            return transactions
        }
        set {
            guard let data = JSONCoder.shared.encode(newValue) else { return }
            KeychainWrapper.standard.set(data, forKey: Constants.transactionsKey)
        }
    }

    public var endOfMonthSummaries: [EndOfMonthSummary] {
        get {
            guard let data = KeychainWrapper.standard.data(forKey: Constants.endOfMonthSummariesKey),
                let endOfMonthSummaries = JSONCoder.shared.decode([EndOfMonthSummary].self, from: data) else {
                    return []
            }
            return endOfMonthSummaries
        }
        set {
            guard let data = JSONCoder.shared.encode(newValue) else { return }
            KeychainWrapper.standard.set(data, forKey: Constants.endOfMonthSummariesKey)
        }
    }

    private init() {}

}
