@testable import MyFinanceKit

struct MockConfigService: ConfigService {

    let isLoggingEnabled = true
    let config = Config(starlingToken: "token", zorkdevToken: "token")

}
