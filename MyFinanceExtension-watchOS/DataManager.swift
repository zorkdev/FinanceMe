import MyFinanceKit

class DataManager {

    struct Constants {
        static let allowanceKey = "allowance"
    }

    static let shared = DataManager()

    private let dataService = KeychainDataService()

    var allowance: String {
        get {
            return dataService.load(key: Constants.allowanceKey) ?? ""
        }
        set {
            dataService.save(value: newValue, key: Constants.allowanceKey)
        }
    }

}
