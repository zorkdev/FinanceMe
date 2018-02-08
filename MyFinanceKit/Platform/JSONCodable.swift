typealias JSON = [String: Any]

typealias JSONCodable = JSONEncodable & JSONDecodable

protocol JSONDecodable: Decodable {

    static var decodeDateFormatter: DateFormatter { get }

}

extension JSONDecodable {

    static var decodeDateFormatter: DateFormatter {
        return Formatters.apiDateTime
    }

    init?(data: Data) {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .formatted(Self.decodeDateFormatter)
        guard let instance = try? jsonDecoder.decode(Self.self, from: data) else { return nil }
        self = instance
    }

}

protocol JSONEncodable: Encodable {

    static var encodeDateFormatter: DateFormatter { get }

}

extension JSONEncodable {

    static var encodeDateFormatter: DateFormatter {
        return Formatters.apiDateTime
    }

    func encoded() -> Data? {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.dateEncodingStrategy = .formatted(Self.encodeDateFormatter)
        return try? jsonEncoder.encode(self)
    }

}

extension Array: JSONCodable {}
extension Dictionary: JSONCodable {}
extension Optional: JSONCodable {}
