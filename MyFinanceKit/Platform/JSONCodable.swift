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
        let dictionary = CodableDictionary(data: data)
        let queryItems = dictionary?.value.map { URLQueryItem(name: $0.key, value: $0.value) }

        return queryItems
    }

}

struct CodableDictionary: JSONDecodable {

    let value: [String: String]

    struct CodingKeys: CodingKey {
        var stringValue: String
        var intValue: Int?

        init?(stringValue: String) {
            self.stringValue = stringValue
        }

        init?(intValue: Int) { return nil }
    }

    init(from decoder: Decoder) throws {
        var dictionary = [String: String]()
        let container = try decoder.container(keyedBy: CodingKeys.self)

        for key in container.allKeys {
            if let string = try? container.decode(String.self, forKey: key) {
                dictionary[key.stringValue] = string
            } else if let bool = try? container.decode(Bool.self, forKey: key) {
                dictionary[key.stringValue] = "\(bool)"
            } else if let int = try? container.decode(Int.self, forKey: key) {
                dictionary[key.stringValue] = "\(int)"
            } else if let double = try? container.decode(Double.self, forKey: key) {
                dictionary[key.stringValue] = "\(double)"
            } else {
                throw AppError.jsonParsingError
            }
        }
        value = dictionary
    }

}
