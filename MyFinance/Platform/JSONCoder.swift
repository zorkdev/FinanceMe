#if os(macOS)
    import Cocoa
    import PromiseKit
#endif

typealias JSON = [String: Any]

class JSONCoder {

    static let shared = JSONCoder()

    private let jsonDecoder = JSONDecoder()
    private let jsonEncoder = JSONEncoder()

    private init() {
        jsonDecoder.dateDecodingStrategy = .formatted(Formatters.apiDateTime)
        jsonEncoder.dateEncodingStrategy = .formatted(Formatters.apiDateTime)
    }

    func decode<T>(_ type: T.Type, from data: Data) -> T? where T: Decodable {
        return try? jsonDecoder.decode(type, from: data)
    }

    func encode<T>(_ value: T) -> Data? where T: Encodable {
        return try? jsonEncoder.encode(value)
    }

}
