class NetworkManager {

    enum HTTPMethod: String {
        case post = "POST"
        case get = "GET"
        case put = "PUT"
        case delete = "DELETE"
    }

    private struct Constants {
        static let authHeaderKey = "Authorization"
        static let contentKey = "Accept"
        static let contentValue = "application/json"
        static let encodingKey = "Accept-Encoding"
        static let encodingValue = "gzip, deflate"

        static let authHeaderValue: (String) -> String = {
            return "Bearer \($0)"
        }
    }

    static let shared = NetworkManager()

    private init() {}

    func performRequest(method: HTTPMethod,
                        url: URL,
                        parameters: JSON? = nil,
                        body: Data? = nil) -> Promise<Data> {

        let request = createRequest(method: method,
                                    url: url,
                                    parameters: parameters,
                                    body: body)
        printRequest(request)

        return URLSession.shared.dataTask(with: request).then { data in
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

    private func createRequest(method: HTTPMethod,
                               url: URL,
                               parameters: JSON?,
                               body: Data?) -> URLRequest {
        var request = URLRequest(url: url)

        request.httpMethod = method.rawValue

        request.setValue(Constants.contentValue,
                         forHTTPHeaderField: Constants.contentKey)
        request.setValue(Constants.encodingValue,
                         forHTTPHeaderField: Constants.encodingKey)

        if let token = AuthManager.shared.token?.token {
            request.setValue(Constants.authHeaderValue(token),
                             forHTTPHeaderField: Constants.authHeaderKey)
        }

        if let parameters = parameters,
            let urlWithParameters = URL(string: url.absoluteString + parameters.urlQuery) {
            request.url = urlWithParameters
        }

        if let body = body {
            request.httpBody = body
        }

        return request
    }

}

// MARK: - Debug prints

extension NetworkManager {

    func printRequest(_ request: URLRequest) {
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
        print(
            """
            ********** API Response *********
            \(data.prettyPrinted)
            *********************************

            """
        )
    }

    func printResponse(_ error: Error) {
        print(
            """
            ********** API Error ***********
            \(error)
            *********************************

            """
        )
    }

}
