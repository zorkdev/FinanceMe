public struct HTTPError: Error, Equatable {
    public let code: Int

    init?(code: Int) {
        if case 200...299 = code { return nil }
        self.code = code
    }
}
