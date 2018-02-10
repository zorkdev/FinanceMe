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
        return dataService.load()
    }

    static func all() -> [Self] {
        return dataService.load() ?? []
    }

    func save() {
        Self.dataService.save(value: self)
    }

}

extension Array: Storeable {}

public protocol DataService {

    func save(value: JSONEncodable)
    func load<T: JSONDecodable>() -> T?

}

public struct KeychainDataService: DataService {

    public func save(value: JSONEncodable) {
        guard let data = value.encoded() else { return }
        let key = String(describing: type(of: value))
        KeychainWrapper.standard.set(data, forKey: key)
    }

    public func load<T: JSONDecodable>() -> T? {
        let key = String(describing: T.self)
        guard let data = KeychainWrapper.standard.data(forKey: key) else { return nil }

        return T(data: data)
    }

}

public struct UserDefaultsDataService: DataService {

    public func save(value: JSONEncodable) {
        guard let data = value.encoded() else { return }
        let key = String(describing: type(of: value))
        UserDefaults.standard.set(data, forKey: key)
    }

    public func load<T: JSONDecodable>() -> T? {
        let key = String(describing: T.self)
        guard let data = UserDefaults.standard.data(forKey: key) else { return nil }

        return T(data: data)
    }

}
