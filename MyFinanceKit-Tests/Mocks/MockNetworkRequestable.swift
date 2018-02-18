import PromiseKit
@testable import MyFinanceKit

class MockNetworkRequestable: NetworkRequestable {

    var lastRequest: URLRequest?

    func perform(request: URLRequest) -> Promise<(data: Data, response: URLResponse)> {
        lastRequest = request
        let response = (data: Data(), response: URLResponse())
        return Promise.value(response)
    }

}
