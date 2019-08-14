protocol ConfigServiceProvider {
    var configService: ConfigService { get }
}

protocol ConfigService {
    var urlScheme: String { get }
    var productName: String { get }
    var accessGroup: String { get }
}

class DefaultConfigService: ConfigService {
    // swiftlint:disable force_cast
    private let teamID: String = { Bundle.main.infoDictionary!["TeamID"] as! String }()

    let urlScheme = "financeme://"
    let productName = "com.zorkdev.FinanceMe"
    var accessGroup: String { teamID + productName }

    init() {}
}
