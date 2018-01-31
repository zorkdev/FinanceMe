#if os(macOS)
import Cocoa
#endif

struct Config: Codable {

    let starlingToken: String
    let zorkdevToken: String

}
