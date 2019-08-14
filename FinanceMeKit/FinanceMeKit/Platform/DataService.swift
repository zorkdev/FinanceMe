protocol Storeable: Codable & StringRepresentable {
    static func load(dataService: DataService) -> Self?
    func save(dataService: DataService) -> Result<Void, Error>
}

extension Storeable {
    static func load(dataService: DataService) -> Self? {
        dataService.load(key: Self.instanceName)
    }

    func save(dataService: DataService) -> Result<Void, Error> {
        dataService.save(value: self, key: Self.instanceName)
    }
}

extension Array: Storeable where Element: Codable {}

protocol DataService {
    @discardableResult
    func save(value: Encodable, key: String) -> Result<Void, Error>

    func load<T: Decodable>(key: String) -> T?
    func removeAll()
}
