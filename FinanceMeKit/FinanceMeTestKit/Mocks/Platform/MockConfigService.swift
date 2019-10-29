@testable import FinanceMeKit

public struct MockConfigService: ConfigService {
    public let urlScheme = URL(string: "urlscheme://")!
    public let productName = "productName"
    public let accessGroup = "accessGroup"

    public init() {}
}
