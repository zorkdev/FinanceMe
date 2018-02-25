import PromiseKit
import MyFinanceKit

class MockNetworkRequestable: NetworkRequestable {

    var lastRequest: URLRequest?
    var returnDataValue: Data?
    var returnErrorValue: Error?

    func perform(request: URLRequest) -> Promise<(data: Data, response: URLResponse)> {
        lastRequest = request

        if let error = returnErrorValue {
            return Promise(error: error)
        }

        var response = (data: Data(), response: URLResponse())

        if let returnDataValue = returnDataValue {
            response.data = returnDataValue
        }

        return .value(response)
    }

}
