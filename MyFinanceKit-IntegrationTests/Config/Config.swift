@testable import MyFinanceKit

let appState = AppState()
let config = Config()

class Config {

    private struct Constants {
        static let configFilename = "config"
        static let configExtension = "json"
    }

    init() {
        let bundle = Bundle(for: Config.self)
        let configURL = bundle.url(forResource: Constants.configFilename,
                                   withExtension: Constants.configExtension)!
        let data = try? Data(contentsOf: configURL)
        let session = Session(data: data!)!
        session.save(dataService: KeychainDataService(configService: ConfigDefaultService()))
    }

}
