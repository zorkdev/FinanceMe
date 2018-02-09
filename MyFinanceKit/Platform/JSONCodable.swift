public typealias JSONCodable = JSONEncodable & JSONDecodable

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
        guard let data = self.encoded() else { return nil }
        let dictionary = [String: String](data: data)
        let queryItems = dictionary?.map { URLQueryItem(name: $0.key, value: $0.value) }

        return queryItems
    }

}

extension Array: JSONCodable {}
extension Dictionary: JSONCodable {}
extension Optional: JSONCodable {}
