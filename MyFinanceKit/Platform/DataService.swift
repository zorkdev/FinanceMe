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

extension Array: Storeable where Element: JSONCodable {}

public enum DataServiceSaveStatus {
    case success, failure
}

public protocol DataService {

    @discardableResult func save(value: JSONEncodable, key: String) -> DataServiceSaveStatus
    func load<T: JSONDecodable>(key: String) -> T?

}

public struct KeychainDataService: DataService {

    public init() {}

    @discardableResult public func save(value: JSONEncodable, key: String) -> DataServiceSaveStatus {
        guard let data = value.encoded() else { return .failure }
        return KeychainWrapper.standard.set(data, forKey: key) ? .success : .failure
    }

    public func load<T: JSONDecodable>(key: String) -> T? {
        guard let data = KeychainWrapper.standard.data(forKey: key) else { return nil }

        return T(data: data)
    }

}

public struct UserDefaultsDataService: DataService {

    public init() {}

    @discardableResult public func save(value: JSONEncodable, key: String) -> DataServiceSaveStatus {
        guard let data = value.encoded() else { return .failure }
        UserDefaults.standard.set(data, forKey: key)
        return .success
    }

    public func load<T: JSONDecodable>(key: String) -> T? {
        guard let data = UserDefaults.standard.data(forKey: key) else { return nil }

        return T(data: data)
    }

}
