import Foundation

enum StarlingAPI: String {
    private static let baseURL = "https://api.starlingbank.com/api/v1/"

    case getBalance = "accounts/balance"

    var url: URL? {
        return URL(string: StarlingAPI.baseURL + rawValue)
    }
}
