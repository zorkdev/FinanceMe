public enum HTTPMethod: String {
    case post = "POST"
    case get = "GET"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

public protocol NetworkRequestable {

    func perform(request: URLRequest) -> Promise<(data: Data, response: URLResponse)>

}

public protocol NetworkServiceType {

    func performRequest<T: JSONDecodable>(api: APIType,
                                          method: HTTPMethod,
                                          parameters: JSONEncodable?,
                                          body: JSONEncodable?) -> Promise<T>

    func performRequest(api: APIType,
                        method: HTTPMethod,
                        parameters: JSONEncodable?,
                        body: JSONEncodable?) -> Promise<Data>

}

public class NetworkService: NetworkServiceType {

    private struct Constants {
        static let authHeaderKey = "Authorization"
        static let contentKey = "Accept"
        static let contentTypeKey = "Content-Type"
        static let contentValue = "application/json"
        static let encodingKey = "Accept-Encoding"
        static let encodingValue = "gzip, deflate"

        static let authHeaderValue: (String) -> String = {
            return "Bearer \($0)"
        }
    }

    private let networkService: NetworkRequestable
    private let configService: ConfigService

    public init(networkRequestable: NetworkRequestable,
                configService: ConfigService) {
        networkService = networkRequestable
        self.configService = configService
    }

    public func performRequest<T: JSONDecodable>(api: APIType,
                                                 method: HTTPMethod,
                                                 parameters: JSONEncodable? = nil,
                                                 body: JSONEncodable? = nil) -> Promise<T> {
        return performRequest(api: api,
                              method: method,
                              parameters: parameters,
                              body: body)
            .then { data -> Promise<T> in
                guard let instance = T(data: data) else {
                    return Promise(error: AppError.jsonParsingError)
                }

                return .value(instance)
        }
    }

    public func performRequest(api: APIType,
                               method: HTTPMethod,
                               parameters: JSONEncodable? = nil,
                               body: JSONEncodable? = nil) -> Promise<Data> {

        guard let request = createRequest(api: api,
                                          method: method,
                                          parameters: parameters,
                                          body: body)
            else {
                return Promise(error: AppError.apiPathInvalid)
        }

        if configService.isLoggingEnabled {
            print(NetworkService.createRequestString(request))
        }

        return Promise { seal in
            networkService.perform(request: request)
                .done { response in
                    if self.configService.isLoggingEnabled {
                        print(NetworkService.createResponseString(response.data))
                    }
                    seal.fulfill(response.data)

                }.catch { error in
                    if self.configService.isLoggingEnabled {
                        print(NetworkService.createResponseString(error))
                    }
                    if let httpError = error as? PMKHTTPError,
                        let apiError = APIError(httpError: httpError) {
                        seal.reject(apiError)
                    } else {
                        seal.reject(error)
                    }
            }
        }
    }

    private func createRequest(api: APIType,
                               method: HTTPMethod,
                               parameters: JSONEncodable?,
                               body: JSONEncodable?) -> URLRequest? {

        guard let url = api.url,
            var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else { return nil }

        urlComponents.queryItems = parameters?.urlEncoded()

        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = method.rawValue

        request.setValue(Constants.contentValue,
                         forHTTPHeaderField: Constants.contentKey)
        request.setValue(Constants.encodingValue,
                         forHTTPHeaderField: Constants.encodingKey)
        request.setValue(Constants.authHeaderValue(api.token(config: configService.config)),
                         forHTTPHeaderField: Constants.authHeaderKey)

        if body != nil {
            request.setValue(Constants.contentValue,
                             forHTTPHeaderField: Constants.contentTypeKey)
        }

        request.httpBody = body?.encoded()

        return request
    }

}

// MARK: - Debug prints

extension NetworkService {

    static func createRequestString(_ request: URLRequest) -> String {
        return
            """
            ********** API Request **********
            \((request.httpMethod!) + " " + (request.url!.absoluteString))
            --- Headers ---
            \(request.allHTTPHeaderFields?.prettyPrinted ?? "nil")
            ---- Body -----
            \(request.httpBody?.prettyPrinted ?? "nil")
            *********************************

            """
    }

    static func createResponseString(_ data: Data) -> String {
        return
            """
            ********** API Response *********
            \(data.prettyPrinted)
            *********************************

            """
    }

    static func createResponseString(_ error: Error) -> String {
        return
            """
            ********** API Error ***********
            \(error)
            *********************************

            """
    }

}
