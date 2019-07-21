public typealias JSONCodable = JSONEncodable & JSONDecodable

extension Array: JSONCodable where Element: JSONCodable {}
extension Dictionary: JSONCodable where Key: JSONCodable, Value: JSONCodable {}
extension Optional: JSONCodable where Wrapped: JSONCodable {}
extension Int: JSONCodable {}
extension Double: JSONCodable {}
extension String: JSONCodable {}

public protocol JSONDecodable: Decodable {
    static var decodeDateFormatter: DateFormatter { get }
}

public extension JSONDecodable {
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

public protocol JSONEncodable: Encodable {
    static var encodeDateFormatter: DateFormatter { get }
}

public extension JSONEncodable {
    static var encodeDateFormatter: DateFormatter {
        return Formatters.apiDateTime
    }

    // swiftlint:disable:next unused_declaration
    var prettyPrinted: String {
        guard let data = self.encoded(prettyPrinted: true),
            let string = String(data: data, encoding: .utf8) else { return "nil" }
        let cleanString = string.replacingOccurrences(of: "\\", with: "")

        return cleanString
    }

    func encoded(prettyPrinted: Bool = false) -> Data? {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = prettyPrinted ? .prettyPrinted : []
        jsonEncoder.dateEncodingStrategy = .formatted(Self.encodeDateFormatter)

        return try? jsonEncoder.encode(self)
    }

    func urlEncoded() -> [URLQueryItem]? {
        let urlFormEncoder = URLFormEncoder(dateFormatter: Self.encodeDateFormatter)

        return try? urlFormEncoder.encode(self)
    }
}
