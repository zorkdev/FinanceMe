public protocol ConfigService {

    var isLoggingEnabled: Bool { get }
    var urlScheme: String { get }
    var config: Config { get }

}

public class ConfigFileService: ConfigService {

    private struct Constants {
        static let configFilename = "config"
        static let configExtension = "json"
        static let configMissingMessage = "The config file is missing or invalid."
    }

    public let isLoggingEnabled = TARGET_OS_SIMULATOR == 1
    public let urlScheme = "myfinance://"

    public let config: Config

    public init?(fatalErrorable: FatalErrorable) {
        let bundle = Bundle(for: ConfigFileService.self)
        guard let configURL = bundle.url(forResource: Constants.configFilename,
                                         withExtension: Constants.configExtension),
            let data = try? Data(contentsOf: configURL),
            let config = Config(data: data) else {
                fatalErrorable.fatalError(message: Constants.configMissingMessage)
                return nil
        }

        self.config = config
    }

}
