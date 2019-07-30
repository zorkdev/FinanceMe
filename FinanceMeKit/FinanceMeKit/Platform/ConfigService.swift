public protocol ConfigService {
    var urlScheme: String { get }
    var productName: String { get }
    var accessGroup: String { get }
}

public struct DefaultConfigService: ConfigService {
    // swiftlint:disable force_cast
    private let teamID: String = { Bundle.main.infoDictionary!["TeamID"] as! String }()

    public let urlScheme: String = {
        let urlTypes = Bundle.main.infoDictionary!["CFBundleURLTypes"] as! [Any]
        let urlTypeDictionary = urlTypes.first as! [String: Any]
        let urlSchemes = urlTypeDictionary["CFBundleURLSchemes"] as! [String]
        return urlSchemes.first! + "://"
    }()

    public let productName: String = { Bundle.main.infoDictionary!["CFBundleIdentifier"] as! String }()
    public var accessGroup: String { teamID + productName }

    public init() {}
}
