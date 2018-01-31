#if os(macOS)
import Cocoa
import PromiseKit
#endif

enum API {
    case starling
    case zorkdev
}

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

enum ZorkdevAPI: String {
    private static let baseURL = "https://zorkdev.herokuapp.com/api/"

    case getUser = "users/me"
    case getTransactions = "transactions"

    var url: URL? {
        return URL(string: ZorkdevAPI.baseURL + rawValue)
    }
}
