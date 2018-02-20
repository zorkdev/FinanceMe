@testable import MyFinanceKit

struct MockConfigService: ConfigService {

    let isLoggingEnabled = true
    let urlScheme = "urlScheme"
    let config = Config(starlingToken: "token", zorkdevToken: "token")

}
