public extension Decodable {
    init(from json: Data) throws {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        self = try decoder.decode(Self.self, from: json)
    }
}

public extension Encodable {
    var prettyPrinted: String {
        guard let data = try? self.jsonEncoded(prettyPrinted: true),
            let string = String(data: data, encoding: .utf8) else { return "nil" }
        return string.replacingOccurrences(of: "\\", with: "")
    }

    func jsonEncoded(prettyPrinted: Bool = false) throws -> Data {
        let encoder = JSONEncoder()
        encoder.outputFormatting = prettyPrinted ? .prettyPrinted : []
        encoder.dateEncodingStrategy = .iso8601
        return try encoder.encode(self)
    }
}
