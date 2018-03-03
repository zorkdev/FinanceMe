public protocol APIType {

    var url: URL? { get }
    func token(session: Session) -> String

}

public enum API: APIType, Equatable {

    case starling(StarlingAPI)
    case zorkdev(ZorkdevAPI)

    public var url: URL? {
        switch self {
        case let .starling(starlingAPI): return starlingAPI.url
        case let .zorkdev(zorkdevAPI): return zorkdevAPI.url
        }
    }

    public func token(session: Session) -> String {
        switch self {
        case let .starling(starlingAPI): return starlingAPI.token(session: session)
        case let .zorkdev(zorkdevAPI): return zorkdevAPI.token(session: session)
        }
    }

}

public enum StarlingAPI: APIType, Equatable {

    static let baseURL = "https://api.starlingbank.com/api/v1/"

    case balance
    case transactions

    private var path: String {
        switch self {
        case .balance: return "accounts/balance"
        case .transactions: return "transactions"
        }
    }

    public var url: URL? {
        return URL(string: StarlingAPI.baseURL + path)
    }

    public func token(session: Session) -> String {
        return session.starlingToken
    }

}

public enum ZorkdevAPI: APIType, Equatable {

    static let baseURL = "https://zorkdev.herokuapp.com/api/"

    case login
    case user
    case transactions
    case transaction(String)
    case endOfMonthSummaries

    private var path: String {
        switch self {
        case .login: return "login"
        case .user: return "users/me"
        case .transactions: return "transactions"
        case .transaction(let id): return "transactions/\(id)"
        case .endOfMonthSummaries: return "endOfMonthSummaries"
        }
    }

    public var url: URL? {
        return URL(string: ZorkdevAPI.baseURL + path)
    }

    public func token(session: Session) -> String {
        return session.zorkdevToken
    }

}

public struct FromToParameters: JSONCodable, Equatable {

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

public struct CredentialsParameters: JSONCodable, Equatable {

    public let email: String
    public let password: String

    public init(email: String, password: String) {
        self.email = email
        self.password = password
    }

}
