import PromiseKit
@testable import MyFinanceKit

class MockNetworkService: NetworkServiceType {

    //swiftlint:disable:next large_tuple
    var lastRequest: (api: APIType, method: HTTPMethod, parameters: JSONEncodable?, body: JSONEncodable?)?
    var returnJSONDecodableValue: JSONDecodable?
    var returnDataValue: Data?
    var returnErrorValue: Error?

    func performRequest<T>(api: APIType,
                           method: HTTPMethod,
                           parameters: JSONEncodable?,
                           body: JSONEncodable?) -> Promise<T> where T: JSONDecodable {

        lastRequest = (api: api, method: method, parameters: parameters, body: body)

        if let error = returnErrorValue {
            return Promise(error: error)
        }

        if let returnJSONDecodableValue = returnJSONDecodableValue as? T {
            return .value(returnJSONDecodableValue)
        }

        return Promise(error: APIError.badRequest)
    }

    func performRequest(api: APIType,
                        method: HTTPMethod,
                        parameters: JSONEncodable?,
                        body: JSONEncodable?) -> Promise<Data> {

        lastRequest = (api: api, method: method, parameters: parameters, body: body)

        if let error = returnErrorValue {
            return Promise(error: error)
        }

        return .value(returnDataValue ?? Data())
    }

}
