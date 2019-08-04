import FinanceMeKit

public class MockDataService: DataService {
    public var savedValues = [Encodable]()
    public var lastSavedKey: String?
    public var saveReturnValue: Result<Void, Error>?

    public var lastLoadedKey: String?
    public var loadReturnValues = [Decodable]()

    public var didCallRemoveAll = false

    public init() {}

    public func save(value: Encodable, key: String) -> Result<Void, Error> {
        savedValues.append(value)
        lastSavedKey = key

        if let saveReturnValue = saveReturnValue {
            return saveReturnValue
        } else {
            return .success(())
        }
    }

    public func load<T: Decodable>(key: String) -> T? {
        lastLoadedKey = key

        if let index = loadReturnValues.firstIndex(where: { $0 is T }) {
            let value = loadReturnValues[index] as? T
            loadReturnValues.remove(at: index)
            return value
        } else {
            return nil
        }
    }

    public func removeAll() {
        savedValues = []
        didCallRemoveAll = true
    }
}
