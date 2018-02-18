@testable import MyFinanceKit

struct MockAPI: APIType {

    let url: URL? = URL(string: "https://www.apple.com")

    func token(config: Config) -> String {
        return config.starlingToken
    }

}
