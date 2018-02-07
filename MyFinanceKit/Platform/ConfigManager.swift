import Foundation

class ConfigManager {

    private struct Constants {
        static let configFilename = "config"
        static let configExtension = "json"
        static let configMissingMessage = "The config file is missing or invalid."
    }

    static let shared = ConfigManager()

    let isLoggingEnabled = true

    let config: Config

    private init() {
        let bundle = Bundle(for: ConfigManager.self)
        guard let configURL = bundle.url(forResource: Constants.configFilename,
                                         withExtension: Constants.configExtension),
            let data = try? Data(contentsOf: configURL),
            let config = Config(data: data) else {
                fatalError(Constants.configMissingMessage)
        }

        self.config = config
    }

}
