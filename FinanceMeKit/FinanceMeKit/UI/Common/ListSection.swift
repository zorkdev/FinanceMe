struct ListSection<T: Identifiable>: Identifiable {
    let title: String
    let rows: [T]
    var id: String { title }
}
