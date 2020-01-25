enum API: APIType, Equatable {
    case login
    case user
    case transactions
    case transaction(UUID)
    case summary
    case reconcile
    case deviceToken
    case metrics

    private static let baseURL: String = {
        #if DEBUG
        return "https://financeme-staging.attilanemet.com/api/"
        #else
        return "https://financeme.attilanemet.com/api/"
        #endif
    }()

    private var path: String {
        switch self {
        case .login: return "login"
        case .user: return "users/me"
        case .transactions: return "transactions"
        case .transaction(let id): return "transactions/\(id.uuidString)"
        case .summary: return "endOfMonthSummaries"
        case .reconcile: return "reconcile"
        case .deviceToken: return "deviceToken"
        case .metrics: return "metrics"
        }
    }

    var url: URL { URL(string: Self.baseURL + path)! }
}
