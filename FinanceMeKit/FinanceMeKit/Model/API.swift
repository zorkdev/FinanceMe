enum API: APIType, Equatable {
    case login
    case user
    case transactions
    case transaction(UUID)
    case endOfMonthSummaries
    case reconcile
    case deviceToken

    private static let baseURL = "https://zorkdev-staging.herokuapp.com/api/"

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
}
