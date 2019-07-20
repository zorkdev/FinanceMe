@testable import MyFinanceKit

struct MockAPI: APIType {
    var url: URL? = URL(string: "https://www.apple.com")

    func token(session: Session) -> String {
        return session.starlingToken
    }
}
