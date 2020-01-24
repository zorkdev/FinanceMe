extension JSONDecoder {
    static var `default`: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
}

extension Decodable {
    init(from json: Data) throws {
        self = try JSONDecoder.default.decode(Self.self, from: json)
    }
}

extension Encodable {
    var prettyPrinted: String {
        guard let data = try? self.jsonEncoded(prettyPrinted: true).get() else { return "nil" }
        return data.utf8String
    }

    func jsonEncoded(prettyPrinted: Bool = false) -> Result<Data, Error> {
        let encoder = JSONEncoder()
        encoder.outputFormatting = prettyPrinted ? .prettyPrinted : []
        encoder.dateEncodingStrategy = .iso8601
        return Result { try encoder.encode(self) }
    }
}
