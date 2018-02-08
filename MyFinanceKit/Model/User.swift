public struct User: JSONCodable {

    public let name: String
    public let payday: Int
    public let startDate: Date
    public let largeTransaction: Double
    public let allowance: Double

}
