struct APIError: Error, LocalizedError, Equatable {
    struct Response: Codable, Equatable {
        let reason: String
    }

    let code: Int
    let reason: String

    var errorDescription: String? { "\(reason) (\(code))" }

    init?(code: Int, response: Data) {
        if case 200...299 = code { return nil }
        self.code = code
        self.reason = (try? Response(from: response).reason) ?? "Unknown error"
    }
}
