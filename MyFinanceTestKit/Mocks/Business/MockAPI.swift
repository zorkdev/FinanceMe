@testable import MyFinanceKit

struct MockAPI: APIType {

    var url: URL? = URL(string: "https://www.apple.com")

    func token(config: Config) -> String {
        return config.starlingToken
    }

}
