enum StarlingAPI: String {
    private static let baseURL = "https://api.starlingbank.com/api/v1/"

    case getBalance = "accounts/balance"
    case getTransactions = "transactions"

    var url: URL? {
        return URL(string: StarlingAPI.baseURL + rawValue)
    }
}

enum StarlingParameters: String {

    case from
    case to

}
