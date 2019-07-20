public protocol ConfigService {
    var urlScheme: String { get }
    var productName: String { get }
    var accessGroup: String { get }
    var isLoggingEnabled: Bool { get }
}

public struct ConfigDefaultService: ConfigService {
    private let teamID: String = { (Bundle.main.infoDictionary!["TeamID"] as? String)! }()

    public let urlScheme = "myfinance://"
    public let productName = "com.attilanemet.MyFinance"

    public var accessGroup: String { return teamID + productName }

    public let isLoggingEnabled = TARGET_OS_SIMULATOR == 1

    public init() {}
}
