import Foundation

class AuthManager {

    private struct Constants {
        static let configFilename = "config"
        static let configExtension = "json"
    }

    static let shared = AuthManager()

    private init() {}

    var token: Token? {
        guard let configURL = Bundle.main.url(forResource: Constants.configFilename,
                                              withExtension: Constants.configExtension),
            let data = try? Data(contentsOf: configURL),
            let token = JSONCoder.shared.decode(Token.self, from: data) else { return nil }

        return token
    }

}
