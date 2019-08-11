struct HTTPError: Error, Equatable {
    let code: Int

    init?(code: Int) {
        if case 200...299 = code { return nil }
        self.code = code
    }
}
