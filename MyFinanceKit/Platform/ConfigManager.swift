import Foundation

class ConfigManager {

    private struct Constants {
        static let configFilename = "config"
        static let configExtension = "json"
        static let configMissingMessage = "The config file is missing or invalid."
    }

    static let shared = ConfigManager()

    let isLoggingEnabled = true

    var config: Config

    private init() {
        guard let configURL = Bundle.main.url(forResource: Constants.configFilename,
                                              withExtension: Constants.configExtension),
            let data = try? Data(contentsOf: configURL),
            let config = JSONCoder.shared.decode(Config.self, from: data) else {
                fatalError(Constants.configMissingMessage)
        }

        self.config = config
    }

}
