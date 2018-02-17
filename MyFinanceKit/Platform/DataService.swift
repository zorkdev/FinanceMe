import SwiftKeychainWrapper

public protocol Storeable: JSONCodable {

    static var dataService: DataService { get }
    static func load() -> Self?
    static func all() -> [Self]
    func save()

}

public extension Storeable {

    static var dataService: DataService {
        #if os(iOS)
            return KeychainDataService()
        #else
            return UserDefaultsDataService()
        #endif
    }

    static func load() -> Self? {
        let key = String(describing: Self.self)
        return dataService.load(key: key)
    }

    static func all() -> [Self] {
        let key = String(describing: [Self].self)
        return dataService.load(key: key) ?? []
    }

    func save() {
        let key = String(describing: type(of: self))
        Self.dataService.save(value: self, key: key)
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
