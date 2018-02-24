public protocol ConfigService {

    var isLoggingEnabled: Bool { get }
    var config: Config { get }

}

public class ConfigFileService: ConfigService {

    private struct InternalConstants {
        static let configFilename = "config"
        static let configExtension = "json"
    }

    public struct Constants {
        public static let urlScheme = "myfinance://"
    }

    public let isLoggingEnabled = TARGET_OS_SIMULATOR == 1

    public let config: Config

    public init() {
        let bundle = Bundle(for: ConfigFileService.self)
        let configURL = bundle.url(forResource: InternalConstants.configFilename,
                                   withExtension: InternalConstants.configExtension)!
        let data = try? Data(contentsOf: configURL)
        let config = Config(data: data!)!
        self.config = config
    }

}
