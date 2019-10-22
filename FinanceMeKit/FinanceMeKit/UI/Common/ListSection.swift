public struct ListSection<T: Identifiable>: Identifiable {
    public let title: String
    public let rows: [T]
    public var id: String { title }
}
