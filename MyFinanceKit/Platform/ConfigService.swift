public protocol ConfigService {

    var isLoggingEnabled: Bool { get }
    var urlScheme: String { get }
    var config: Config { get }

}

public class ConfigFileService: ConfigService {

    private struct Constants {
        static let configFilename = "config"
        static let configExtension = "json"
    }

    public let isLoggingEnabled = TARGET_OS_SIMULATOR == 1
    public let urlScheme = "myfinance://"

    public let config: Config

    public init() {
        let bundle = Bundle(for: ConfigFileService.self)
        let configURL = bundle.url(forResource: Constants.configFilename,
                                   withExtension: Constants.configExtension)!
        let data = try? Data(contentsOf: configURL)
        let config = Config(data: data!)!
        self.config = config
    }

}
