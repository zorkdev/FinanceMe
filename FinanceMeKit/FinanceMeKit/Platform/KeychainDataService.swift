final class KeychainDataService: DataService {
    private struct KeychainError: Error, LocalizedError {
        let status: OSStatus
        var message: String { String(SecCopyErrorMessageString(status, nil)!) }
        var errorDescription: String? { "\(message) (\(status))" }
    }

    private let loggingService: LoggingService
    private let service: String
    private let accessGroup: String

    init(configService: ConfigService, loggingService: LoggingService) {
        self.loggingService = loggingService
        self.service = configService.productName
        self.accessGroup = configService.accessGroup
    }

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
        case errSecSuccess:
            return .success(())
        case errSecDuplicateItem:
            return update(value: data, key: key)
        default:
            log(error: status)
            return .failure(KeychainError(status: status))
        }
    }

    func load<T: Decodable>(key: String) -> T? {
        var query = createQuery(key: key)
        query[kSecMatchLimit] = kSecMatchLimitOne
        query[kSecReturnData] = kCFBooleanTrue

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        switch status {
        case errSecItemNotFound:
            return nil
        case errSecSuccess:
            guard let data = result as? Data else { return nil }
            return try? T(from: data)
        default:
            log(error: status)
            return nil
        }
    }

    func removeAll() {
        let query = [kSecClass: kSecClassGenericPassword,
                     kSecAttrService: service,
                     kSecAttrAccessGroup: accessGroup,
                     kSecAttrSynchronizable: kCFBooleanTrue!] as CFDictionary
        let status = SecItemDelete(query)
        if status != errSecSuccess, status != errSecItemNotFound { log(error: status) }
    }

    func update(value: Data, key: String) -> Result<Void, Error> {
        let query = createQuery(key: key) as CFDictionary
        let updateDictionary = [kSecValueData: value] as CFDictionary
        let status = SecItemUpdate(query, updateDictionary)

        switch status {
        case errSecSuccess:
            return .success(())
        default:
            log(error: status)
            return .failure(KeychainError(status: status))
        }
    }
}

private extension KeychainDataService {
    func createQuery(key: String) -> [CFString: Any] {
        var query: [CFString: Any] = [kSecClass: kSecClassGenericPassword]
        query[kSecAttrService] = service
        query[kSecAttrAccessGroup] = accessGroup
        query[kSecAttrSynchronizable] = kCFBooleanTrue
        query[kSecAttrGeneric] = key
        query[kSecAttrAccount] = key
        return query
    }

    private func log(error: OSStatus) {
        loggingService.log(title: "Keychain Error",
                           content: KeychainError(status: error).localizedDescription,
                           type: .error)
    }
}
