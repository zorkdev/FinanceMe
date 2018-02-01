class DataManager {

    private struct Constants {
        static let balanceKey = "balance"
        static let allowanceKey = "allowance"
    }

    static let shared = DataManager()

    var balance: Double {
        get {
            return UserDefaults.standard.double(forKey: Constants.balanceKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Constants.balanceKey)
        }
    }

    var allowance: Double {
        get {
            return UserDefaults.standard.double(forKey: Constants.allowanceKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Constants.allowanceKey)
        }
    }

    private init() {}

}
