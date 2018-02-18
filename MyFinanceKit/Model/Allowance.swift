public struct Allowance: Storeable {

    public let allowance: Double

    public var formatted: String {
        return Formatters.currency.string(from: NSNumber(value: allowance)) ?? ""
    }

    public init(allowance: Double) {
        self.allowance = allowance
    }

}
