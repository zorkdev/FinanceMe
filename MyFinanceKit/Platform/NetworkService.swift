enum HTTPMethod: String {
    case post = "POST"
    case get = "GET"
    case put = "PUT"
    case delete = "DELETE"
}

protocol NetworkRequestable {

    func perform(request: URLRequest) -> Promise<Data>

}

protocol NetworkServiceType {

    func performRequest<T: JSONDecodable>(api: API,
                                          method: HTTPMethod,
                                          parameters: JSONEncodable?,
                                          body: JSONEncodable?) -> Promise<T>

    func performRequest(api: API,
                        method: HTTPMethod,
                        parameters: JSONEncodable?,
                        body: JSONEncodable?) -> Promise<Data>

}

class NetworkService: NetworkServiceType {

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

    static let shared = NetworkService()

    private let networkService: NetworkRequestable

    private init() {
        networkService = URLSession.shared
    }

    func performRequest<T: JSONDecodable>(api: API,
                                          method: HTTPMethod,
                                          parameters: JSONEncodable? = nil,
                                          body: JSONEncodable? = nil) -> Promise<T> {
        return performRequest(api: api,
                              method: method,
                              parameters: parameters,
                              body: body)
            .then { data in
                guard let instance = T(data: data) else {
                    return Promise(error: AppError.jsonParsingError)
                }

                return Promise(value: instance)
        }
    }

    func performRequest(api: API,
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

        printRequest(request)

        return networkService.perform(request: request).then { data in
            self.printResponse(data)
            return Promise(value: data)

        }.recover { error -> Promise<Data> in
            self.printResponse(error)

            if let urlError = error as? PMKURLError,
                let apiError = APIError(urlError: urlError) {
                return Promise(error: apiError)

            } else {
                return Promise(error: error)
            }
        }
    }

    private func createRequest(api: API,
                               method: HTTPMethod,
                               parameters: JSONEncodable?,
                               body: JSONEncodable?) -> URLRequest? {

        guard let url = api.url else { return nil }

        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = parameters?.urlEncoded()

        var request = URLRequest(url: urlComponents?.url ?? url)
        request.httpMethod = method.rawValue

        request.setValue(Constants.contentValue,
                         forHTTPHeaderField: Constants.contentKey)
        request.setValue(Constants.encodingValue,
                         forHTTPHeaderField: Constants.encodingKey)
        request.setValue(Constants.authHeaderValue(api.token),
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

    func printRequest(_ request: URLRequest) {
        guard ConfigManager.shared.isLoggingEnabled else { return }
        print(
            """
            ********** API Request **********
            \((request.httpMethod ?? "") + " " + (request.url?.absoluteString ?? ""))
            --- Headers ---
            \(request.allHTTPHeaderFields?.prettyPrinted ?? "nil")
            ---- Body -----
            \(request.httpBody?.prettyPrinted ?? "nil")
            *********************************

            """
        )
    }

    func printResponse(_ data: Data) {
        guard ConfigManager.shared.isLoggingEnabled else { return }
        print(
            """
            ********** API Response *********
            \(data.prettyPrinted)
            *********************************

            """
        )
    }

    func printResponse(_ error: Error) {
        guard ConfigManager.shared.isLoggingEnabled else { return }
        print(
            """
            ********** API Error ***********
            \(error)
            *********************************

            """
        )
    }

}
