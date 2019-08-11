public protocol ConfigServiceProvider {
    var configService: ConfigService { get }
}

public protocol ConfigService {
    var urlScheme: String { get }
    var productName: String { get }
    var accessGroup: String { get }
}

class DefaultConfigService: ConfigService {
    // swiftlint:disable force_cast
    private let teamID: String = { Bundle.main.infoDictionary!["TeamID"] as! String }()

    let urlScheme: String = {
        let urlTypes = Bundle.main.infoDictionary!["CFBundleURLTypes"] as! [Any]
        let urlTypeDictionary = urlTypes.first as! [String: Any]
        let urlSchemes = urlTypeDictionary["CFBundleURLSchemes"] as! [String]
        return urlSchemes.first! + "://"
    }()

    let productName: String = { Bundle.main.infoDictionary!["CFBundleIdentifier"] as! String }()
    var accessGroup: String { teamID + productName }

    init() {}
}
