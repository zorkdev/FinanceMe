import Foundation

enum API {
    case starling
    case zorkdev
}

enum StarlingAPI: String {
    private static let baseURL = "https://api.starlingbank.com/api/v1/"

    case balance = "accounts/balance"
    case transactions = "transactions"

    var url: URL? {
        return URL(string: StarlingAPI.baseURL + rawValue)
    }
}

enum StarlingParameters: String {
    case from
    case to
}

enum ZorkdevAPI {
    private static let baseURL = "https://zorkdev.herokuapp.com/api/"

    case user
    case transactions
    case transaction(String)

    private var path: String {
        switch self {
        case .user: return "users/me"
        case .transactions: return "transactions"
        case .transaction(let id): return "transactions/\(id)"
        }
    }

    var url: URL? {
        return URL(string: ZorkdevAPI.baseURL + path)
    }
}
