@testable import FinanceMeKit

public final class MockDataService: DataService {
    public init() {}

    public var savedValues = [Encodable]()
    public var lastSaveKey: String?
    public var saveReturnValue: Result<Void, Error>?
    public func save(value: Encodable, key: String) -> Result<Void, Error> {
        savedValues.append(value)
        lastSaveKey = key
        return saveReturnValue ?? .failure(NoReturnValueProviderError(function: #function))
    }

    public var lastLoadKey: String?
    public var loadReturnValues = [Decodable]()
    public func load<T: Decodable>(key: String) -> T? {
        lastLoadKey = key

        if let index = loadReturnValues.firstIndex(where: { $0 is T }) {
            let value = loadReturnValues[index] as? T
            loadReturnValues.remove(at: index)
            return value
        }
        return nil
    }

    public var didCallRemoveAll = false
    public func removeAll() {
        savedValues = []
        didCallRemoveAll = true
    }
}
