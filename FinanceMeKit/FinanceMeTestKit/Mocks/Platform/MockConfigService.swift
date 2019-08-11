import FinanceMeKit

public struct MockConfigService: ConfigService {
    public let urlScheme = "urlScheme"
    public let productName = "productName"
    public let accessGroup = "accessGroup"

    public init() {}
}
