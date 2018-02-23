@testable import MyFinanceKit

class MockDataService: DataService {

    var lastSavedValue: JSONEncodable?
    var lastSavedKey: String?
    var saveReturnValue: DataServiceSaveStatus?

    var lastLoadedKey: String?
    var loadReturnValues = [JSONDecodable]()

    func save(value: JSONEncodable, key: String) -> DataServiceSaveStatus {
        lastSavedValue = value
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

}
