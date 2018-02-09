enum API {

    case starling(StarlingAPI)
    case zorkdev(ZorkdevAPI)

    var token: String {
        switch self {
        case .starling: return ConfigManager.shared.config.starlingToken
        case .zorkdev: return ConfigManager.shared.config.zorkdevToken
        }
    }

    var url: URL? {
        switch self {
        case let .starling(starlingAPI): return starlingAPI.url
        case let .zorkdev(zorkdevAPI): return zorkdevAPI.url
        }
    }

}

protocol APIType {

    static var baseURL: String { get }
    var url: URL? { get }

}

enum StarlingAPI: String, APIType {

    static let baseURL = "https://api.starlingbank.com/api/v1/"

    case balance = "accounts/balance"
    case transactions = "transactions"

    var url: URL? {
        return URL(string: StarlingAPI.baseURL + rawValue)
    }

}

enum ZorkdevAPI: APIType {

    static let baseURL = "https://zorkdev.herokuapp.com/api/"

    case user
    case transactions
    case transaction(String)
    case endOfMonthSummaries

    private var path: String {
        switch self {
        case .user: return "users/me"
        case .transactions: return "transactions"
        case .transaction(let id): return "transactions/\(id)"
        case .endOfMonthSummaries: return "endOfMonthSummaries"
        }
    }

    var url: URL? {
        return URL(string: ZorkdevAPI.baseURL + path)
    }

}

public struct FromToParameters: JSONCodable {

    public static var decodeDateFormatter: DateFormatter {
        return Formatters.apiDate
    }

    public static var encodeDateFormatter: DateFormatter {
        return Formatters.apiDate
    }

    public let from: Date?
    public let to: Date?

    public init(from: Date?, to: Date?) {
        self.from = from
        self.to = to
    }

}
