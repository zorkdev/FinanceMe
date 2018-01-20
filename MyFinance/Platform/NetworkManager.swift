import Foundation

class NetworkManager {

    enum HTTPMethod: String {
        case post = "POST"
        case get = "GET"
        case put = "PUT"
        case delete = "DELETE"
    }

    enum HTTPStatus: Int {
        case ok = 200
        case accepted = 202
        case badRequest = 400
        case unauthorized = 401
        case forbidden = 403
        case notFound = 404
        case serverError = 500
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
                        parameters: [String: Any]? = nil,
                        body: Data? = nil,
                        completion: @escaping (Error?, Data?) -> Void) {

        guard let token = AuthManager.shared.token?.token else {
            completion(AppError.tokenNotFound, nil)
            return
        }

        var url = url
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
                completion(AppError.urlQueryInvalid, nil)
                return
            }
            url = urlWithParameters
        }

        if let body = body {
            request.httpBody = body
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if error != nil {
                    guard let statusCode = (response as? HTTPURLResponse)?.statusCode,
                        let status = NetworkManager.HTTPStatus(rawValue: statusCode) else {
                        completion(AppError.unknownError, nil)
                        return
                    }
                    let apiError = APIError(status: status)
                    completion(apiError, nil)
                } else {
                    completion(nil, data)
                }
            }
        }
        task.resume()
    }

}
