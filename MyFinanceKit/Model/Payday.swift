public struct Payday {

    public let intValue: Int
    public var stringValue: String { return "\(intValue)" }

}

extension Payday: Describable {

    public var description: String { return stringValue }

}

public struct Paydays {

    private static let range = 1...28

    public static let values = range.map { Payday(intValue: $0) }

}
