import SwiftKeychainWrapper

public typealias JSONCodableAndStringRepresentable = JSONCodable & StringRepresentable

public protocol Storeable: JSONCodableAndStringRepresentable {

    static func load(dataService: DataService) -> Self?
    static func all(dataService: DataService) -> [Self]
    func save(dataService: DataService)

}

public extension Storeable {

    static func load(dataService: DataService) -> Self? {
        let key = Self.instanceName
        return dataService.load(key: key)
    }

    static func all(dataService: DataService) -> [Self] {
        let key = [Self].instanceName
        return dataService.load(key: key) ?? []
    }

    func save(dataService: DataService) {
        let key = self.instanceName
        dataService.save(value: self, key: key)
    }

}

extension Array: Storeable {}

public protocol DataService {

    func save(value: JSONEncodable, key: String)
    func load<T: JSONDecodable>(key: String) -> T?

}

public struct KeychainDataService: DataService {

    public init() {}

    public func save(value: JSONEncodable, key: String) {
        guard let data = value.encoded() else { return }
        KeychainWrapper.standard.set(data, forKey: key)
    }

    public func load<T: JSONDecodable>(key: String) -> T? {
        guard let data = KeychainWrapper.standard.data(forKey: key) else { return nil }

        return T(data: data)
    }

}

public struct UserDefaultsDataService: DataService {

    public init() {}

    public func save(value: JSONEncodable, key: String) {
        guard let data = value.encoded() else { return }
        UserDefaults.standard.set(data, forKey: key)
    }

    public func load<T: JSONDecodable>(key: String) -> T? {
        guard let data = UserDefaults.standard.data(forKey: key) else { return nil }

        return T(data: data)
    }

}
