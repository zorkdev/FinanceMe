public class DataManager {

    private struct Constants {
        static let userKey = "user"
        static let balanceKey = "balance"
        static let transactionsKey = "transactions"
        static let endOfMonthSummariesKey = "endOfMonthSummaries"
        static let currentMonthSummaryKey = "currentMonthSummary"
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

    public var user: User? {
        get {
            guard let data = KeychainWrapper.standard.data(forKey: Constants.userKey),
                let user = User.self(data: data) else {
                    return nil
            }
            return user
        }
        set {
            guard let data = newValue.encoded() else { return }
            KeychainWrapper.standard.set(data, forKey: Constants.userKey)
        }
    }

    public var transactions: [Transaction] {
        get {
            guard let data = KeychainWrapper.standard.data(forKey: Constants.transactionsKey),
                let transactions = [Transaction](data: data) else {
                    return []
            }
            return transactions
        }
        set {
            guard let data = newValue.encoded() else { return }
            KeychainWrapper.standard.set(data, forKey: Constants.transactionsKey)
        }
    }

    public var endOfMonthSummaries: [EndOfMonthSummary] {
        get {
            guard let data = KeychainWrapper.standard.data(forKey: Constants.endOfMonthSummariesKey),
                let endOfMonthSummaries = [EndOfMonthSummary](data: data) else {
                    return []
            }
            return endOfMonthSummaries
        }
        set {
            guard let data = newValue.encoded() else { return }
            KeychainWrapper.standard.set(data, forKey: Constants.endOfMonthSummariesKey)
        }
    }

    public var currentMonthSummary: CurrentMonthSummary? {
        get {
            guard let data = KeychainWrapper.standard.data(forKey: Constants.currentMonthSummaryKey),
                let currentMonthSummary = CurrentMonthSummary(data: data) else {
                    return nil
            }
            return currentMonthSummary
        }
        set {
            guard let data = newValue.encoded() else { return }
            KeychainWrapper.standard.set(data, forKey: Constants.currentMonthSummaryKey)
        }
    }

    private init() {}

}
