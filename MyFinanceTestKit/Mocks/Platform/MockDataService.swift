import MyFinanceKit

class MockDataService: DataService {

    var savedValues = [JSONEncodable]()
    var lastSavedKey: String?
    var saveReturnValue: DataServiceSaveStatus?

    var lastLoadedKey: String?
    var loadReturnValues = [JSONDecodable]()

    var didCallRemoveAll = false

    func save(value: JSONEncodable, key: String) -> DataServiceSaveStatus {
        savedValues.append(value)
        lastSavedKey = key

        if let saveReturnValue = saveReturnValue {
            return saveReturnValue
        } else {
            return .success
        }
    }

    func load<T>(key: String) -> T? where T: JSONDecodable {
        lastLoadedKey = key

        if let index = loadReturnValues.index(where: { $0 is T }) {
            let value = loadReturnValues[index] as? T
            loadReturnValues.remove(at: index)
            return value
        } else {
            return nil
        }
    }

    func removeAll() {
        savedValues = []
        didCallRemoveAll = true
    }

}
