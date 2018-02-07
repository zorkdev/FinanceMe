import Foundation

typealias JSON = [String: Any]

public extension Decodable {

    init?(data: Data) {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .formatted(Formatters.apiDateTime)
        guard let instance = try? jsonDecoder.decode(Self.self, from: data) else { return nil }
        self = instance
    }

}

public extension Encodable {

    func encoded() -> Data? {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.dateEncodingStrategy = .formatted(Formatters.apiDateTime)
        return try? jsonEncoder.encode(self)
    }

}
