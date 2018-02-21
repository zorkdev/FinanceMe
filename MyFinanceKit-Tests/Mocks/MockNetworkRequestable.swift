import PromiseKit
@testable import MyFinanceKit

class MockNetworkRequestable: NetworkRequestable {

    var lastRequest: URLRequest?
    var returnDataValue: Data?

    func perform(request: URLRequest) -> Promise<(data: Data, response: URLResponse)> {
        lastRequest = request
        var response = (data: Data(), response: URLResponse())

        if let returnDataValue = returnDataValue {
            response.data = returnDataValue
        }

        return .value(response)
    }

}
