public class KeychainDataService: DataService {
    private let service: String
    private let accessGroup: String

    public init(configService: ConfigService) {
        self.service = configService.productName
        self.accessGroup = configService.accessGroup
    }

    @discardableResult
    public func save(value: JSONEncodable, key: String) -> DataServiceStatus {
        guard let data = value.encoded() else { return .failure }

        var query = createQuery(key: key)
        query[kSecValueData] = data
        query[kSecAttrAccessible] = kSecAttrAccessibleAfterFirstUnlock

        let status = SecItemAdd(query as CFDictionary, nil)

        switch status {
        case errSecSuccess: return .success
        case errSecDuplicateItem: return update(value: data, key: key)
        default: return .failure
        }
    }

    public func load<T: JSONDecodable>(key: String) -> T? {
        var query = createQuery(key: key)
        query[kSecMatchLimit] = kSecMatchLimitOne
        query[kSecReturnData] = kCFBooleanTrue

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        guard status == noErr,
            let data = result as? Data,
            let value = T(data: data) else { return nil }

        return value
    }

    @discardableResult
    public func delete(key: String) -> DataServiceStatus {
        let query = createQuery(key: key) as CFDictionary
        let status = SecItemDelete(query)

        return status == errSecSuccess ? .success : .failure
    }

    public func removeAll() {
        let secClasses = [kSecClassGenericPassword,
                          kSecClassGenericPassword,
                          kSecClassCertificate,
                          kSecClassKey,
                          kSecClassIdentity]

        for secClass in secClasses {
            let query = [kSecClass: secClass,
                         kSecAttrSynchronizable: kCFBooleanTrue!] as CFDictionary
            _ = SecItemDelete(query)
        }
    }
}

// MARK: - Private methods

extension KeychainDataService {
    private func update(value: Data, key: String) -> DataServiceStatus {
        let query = createQuery(key: key) as CFDictionary
        let updateDictionary = [kSecValueData: value] as CFDictionary

        let status = SecItemUpdate(query, updateDictionary)

        return status == errSecSuccess ? .success : .failure
    }

    private func createQuery(key: String) -> [CFString: Any] {
        var query: [CFString: Any] = [kSecClass: kSecClassGenericPassword]
        query[kSecAttrService] = service
        query[kSecAttrAccessGroup] = accessGroup
        query[kSecAttrSynchronizable] = kCFBooleanTrue
        query[kSecAttrGeneric] = key
        query[kSecAttrAccount] = key

        return query
    }
}
