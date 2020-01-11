final class KeychainDataService: DataService {
    private let service: String
    private let accessGroup: String

    init(configService: ConfigService) {
        self.service = configService.productName
        self.accessGroup = configService.accessGroup
    }

    @discardableResult
    func save(value: Encodable, key: String) -> Result<Void, Error> {
        let data: Data
        switch value.jsonEncoded() {
        case .success(let encodedData): data = encodedData
        case .failure(let error): return .failure(error)
        }

        var query = createQuery(key: key)
        query[kSecValueData] = data
        query[kSecAttrAccessible] = kSecAttrAccessibleAfterFirstUnlock

        let status = SecItemAdd(query as CFDictionary, nil)

        switch status {
        case errSecSuccess: return .success(())
        case errSecDuplicateItem: return update(value: data, key: key)
        default: return .failure(NSError(domain: NSOSStatusErrorDomain, code: Int(status), userInfo: nil))
        }
    }

    func load<T: Decodable>(key: String) -> T? {
        var query = createQuery(key: key)
        query[kSecMatchLimit] = kSecMatchLimitOne
        query[kSecReturnData] = kCFBooleanTrue

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        guard status == noErr,
            let data = result as? Data,
            let value = try? T(from: data) else { return nil }

        return value
    }

    func removeAll() {
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

private extension KeychainDataService {
    func update(value: Data, key: String) -> Result<Void, Error> {
        let query = createQuery(key: key) as CFDictionary
        let updateDictionary = [kSecValueData: value] as CFDictionary
        let status = SecItemUpdate(query, updateDictionary)

        switch status {
        case errSecSuccess: return .success(())
        default: return .failure(NSError(domain: NSOSStatusErrorDomain, code: Int(status), userInfo: nil))
        }
    }

    func createQuery(key: String) -> [CFString: Any] {
        var query: [CFString: Any] = [kSecClass: kSecClassGenericPassword]
        query[kSecAttrService] = service
        query[kSecAttrAccessGroup] = accessGroup
        query[kSecAttrSynchronizable] = kCFBooleanTrue
        query[kSecAttrGeneric] = key
        query[kSecAttrAccount] = key
        return query
    }
}
