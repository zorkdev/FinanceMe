import PromiseKit
@testable import MyFinanceKit

class MockNetworkService: NetworkServiceType {

    //swiftlint:disable:next large_tuple
    var lastRequest: (api: APIType, method: HTTPMethod, parameters: JSONEncodable?, body: JSONEncodable?)?
    var returnJSONDecodableValues = [JSONDecodable]()
    var returnDataValue: Data?
    var returnErrorValue: Error?

    func performRequest<T: JSONDecodable>(api: APIType,
                                          method: HTTPMethod,
                                          parameters: JSONEncodable?,
                                          body: JSONEncodable?) -> Promise<T> {

        lastRequest = (api: api, method: method, parameters: parameters, body: body)

        if let error = returnErrorValue {
            return Promise(error: error)
        }

        if let index = returnJSONDecodableValues.index(where: { $0 is T }) {
            let value = returnJSONDecodableValues[index] as? T
            returnJSONDecodableValues.remove(at: index)
            return .value(value!)
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
