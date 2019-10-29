public protocol ConfigService {
    var urlScheme: URL { get }
    var productName: String { get }
    var accessGroup: String { get }
}

class DefaultConfigService: ConfigService {
    // swiftlint:disable force_cast
    private let teamID: String = { Bundle.main.infoDictionary!["TeamID"] as! String }()

    let urlScheme = URL(string: "financeme://")!
    let productName = "com.zorkdev.FinanceMe"
    var accessGroup: String { teamID + productName }

    init() {}
}

#if DEBUG
extension Stub {
    class StubConfigService: ConfigService {
        let urlScheme = URL(string: "urlscheme://")!
        let productName = ""
        let accessGroup = ""
    }
}
#endif
