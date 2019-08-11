enum ZorkdevAPI: APIType, Equatable {
    case login
    case user
    case transactions
    case transaction(UUID)
    case endOfMonthSummaries
    case reconcile
    case deviceToken

    private static let baseURL: String = {
        #if DEBUG
        if isTesting { return "http://localhost:8008" }
        #endif
        return "https://zorkdev.herokuapp.com/api/"
    }()

    private var path: String {
        switch self {
        case .login: return "login"
        case .user: return "users/me"
        case .transactions: return "transactions"
        case .transaction(let id): return "transactions/\(id.uuidString)"
        case .endOfMonthSummaries: return "endOfMonthSummaries"
        case .reconcile: return "reconcile"
        case .deviceToken: return "deviceToken"
        }
    }

    var url: URL { URL(string: Self.baseURL + path)! }

    func token(session: Session) -> String {
        session.token
    }
}

enum StarlingAPI: APIType, Equatable {
    case balance

    private static let baseURL: String = {
        #if DEBUG
        if isTesting { return "http://localhost:8008" }
        #endif
        return "https://api.starlingbank.com/api/v1/"
    }()

    private var path: String {
        switch self {
        case .balance: return "accounts/balance"
        }
    }

    var url: URL { URL(string: Self.baseURL + path)! }

    func token(session: Session) -> String {
        session.sToken
    }
}
