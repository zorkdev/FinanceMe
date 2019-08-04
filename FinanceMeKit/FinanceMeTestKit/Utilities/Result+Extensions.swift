public extension Result {
    func forceGet() -> Success {
        // swiftlint:disable:next force_try
        try! get()
    }
}
