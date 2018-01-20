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

        guard let token = AuthManager.shared.token?.token else {
            return Promise(error: AppError.tokenNotFound)
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue(Constants.authHeaderValue(token),
                         forHTTPHeaderField: Constants.authHeaderKey)
        request.setValue(Constants.contentValue,
                         forHTTPHeaderField: Constants.contentKey)
        request.setValue(Constants.encodingValue,
                         forHTTPHeaderField: Constants.encodingKey)

        if let parameters = parameters {
            let urlString = url.absoluteString + parameters.urlQuery
            guard let urlWithParameters = URL(string: urlString) else {
                return Promise(error: AppError.urlQueryInvalid)
            }
            request.url = urlWithParameters
        }

        if let body = body {
            request.httpBody = body
        }

        return URLSession.shared.dataTask(with: request).then { data in
            //print(data.prettyPrinted)
            return Promise(value: data)
        }.recover { error -> Promise<Data> in
            if let urlError = error as? PMKURLError,
                let apiError = APIError(urlError: urlError) {
                return Promise(error: apiError)
            } else {
                return Promise(error: error)
            }
        }
    }

}
