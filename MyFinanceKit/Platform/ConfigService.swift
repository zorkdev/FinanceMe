public protocol ConfigService {

    var urlScheme: String { get }
    var productName: String { get }
    var accessGroup: String { get }
    var isLoggingEnabled: Bool { get }

}

public struct ConfigDefaultService: ConfigService {

    public let urlScheme = "myfinance://"
    public let productName = "com.attilanemet.MyFinance"

    public let accessGroup: String = {
        return (Bundle.main.infoDictionary!["TeamID"] as! String) + "com.attilanemet.MyFinance"
    }()

    public let isLoggingEnabled = TARGET_OS_SIMULATOR == 1

    public init() {}

}
