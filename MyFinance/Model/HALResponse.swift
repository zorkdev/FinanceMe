#if os(macOS)
import Cocoa
#endif

struct HALResponse<T: Codable>: Codable {

    enum CodingKeys: String, CodingKey {
        case embedded = "_embedded"
    }

    let embedded: T

}
