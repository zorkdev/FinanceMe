import Combine

enum HTTPMethod: String {
    case post = "POST"
    case get = "GET"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

protocol APIType {
    var url: URL { get }
}

protocol NetworkRequestable {
    func perform(request: URLRequest) -> AnyPublisher<(data: Data, response: URLResponse), URLError>
}

protocol NetworkService {
    func perform(api: APIType, method: HTTPMethod, body: Encodable?) -> AnyPublisher<Data, Error>
    func perform<T: Decodable>(api: APIType, method: HTTPMethod, body: Encodable?) -> AnyPublisher<T, Error>
}

extension NetworkService {
    func perform<T: Decodable>(api: APIType, method: HTTPMethod, body: Encodable?) -> AnyPublisher<T, Error> {
        perform(api: api, method: method, body: body)
            .decode(type: T.self, decoder: JSONDecoder.default)
            .eraseToAnyPublisher()
    }
}

class DefaultNetworkService: NetworkService {
    private enum Constants {
        static let authHeaderKey = "Authorization"
        static let contentKey = "Accept"
        static let contentTypeKey = "Content-Type"
        static let contentValue = "application/json"

        static let authHeaderValue: (String) -> String = { "Bearer \($0)" }
    }

    private let networkRequestable: NetworkRequestable
    private let loggingService: LoggingService
    private let sessionService: SessionService

    init(networkRequestable: NetworkRequestable,
         loggingService: LoggingService,
         sessionService: SessionService) {
        self.networkRequestable = networkRequestable
        self.loggingService = loggingService
        self.sessionService = sessionService
    }

    func perform(api: APIType, method: HTTPMethod, body: Encodable?) -> AnyPublisher<Data, Error> {
        let request: URLRequest
        switch createURLRequest(api: api, method: method, body: body) {
        case .success(let urlRequest): request = urlRequest
        case .failure(let error): return Fail(error: error).eraseToAnyPublisher()
        }

        loggingService.log(
            title: "API Request",
            content: Self.createRequestString(request))

        let startTime = CFAbsoluteTimeGetCurrent()

        return networkRequestable.perform(request: request)
            .tryMap { response in
                guard let urlResponse = response.response as? HTTPURLResponse else {
                    let error = APIError(code: 1, response: response.data)!
                    self.loggingService.log(
                        title: "API Error",
                        content: Self.createResponseString(error, data: response.data, response: nil),
                        type: .error)
                    throw error
                }

                if let error = APIError(code: urlResponse.statusCode, response: response.data) {
                    self.loggingService.log(
                        title: "API Error",
                        content: Self.createResponseString(error, data: response.data, response: urlResponse),
                        type: .error)
                    throw error
                }

                let endTime = CFAbsoluteTimeGetCurrent() - startTime

                self.loggingService.log(
                    title: "API Response",
                    content: Self.createResponseString(response.data, response: urlResponse, time: endTime))
                return response.data
            }.eraseToAnyPublisher()
    }
}

private extension DefaultNetworkService {
    func createURLRequest(api: APIType, method: HTTPMethod, body: Encodable?) -> Result<URLRequest, Error> {
        var request = URLRequest(url: api.url)
        request.httpMethod = method.rawValue
        request.setValue(Constants.contentValue, forHTTPHeaderField: Constants.contentKey)
        request.setValue(Constants.contentValue, forHTTPHeaderField: Constants.contentTypeKey)

        if let data = body as? Data {
            request.httpBody = data
        } else {
            switch body?.jsonEncoded() {
            case .success(let data): request.httpBody = data
            case .failure(let error): return .failure(error)
            case nil: break
            }
        }

        if let session = sessionService.session {
            request.setValue(Constants.authHeaderValue(session.token), forHTTPHeaderField: Constants.authHeaderKey)
        }

        return .success(request)
    }
}

// MARK: - Debug prints

extension DefaultNetworkService {
    static func createRequestString(_ request: URLRequest) -> String {
        """
        \((request.httpMethod!) + " " + (request.url!.absoluteString))
        --- Headers ---
        \(request.allHTTPHeaderFields?.prettyPrinted ?? "nil")
        ---- Body -----
        \(request.httpBody?.prettyPrinted ?? "nil")
        """
    }

    static func createResponseString(_ data: Data, response: HTTPURLResponse, time: TimeInterval) -> String {
        """
        Response time: \(Int(time * 1000))ms
        ----- URL -----
        \(response.url!.absoluteString)
        --- Status ----
        \(response.statusCode)
        --- Headers ---
        \((response.allHeaderFields as? [String: String])!.prettyPrinted)
        ---- Body -----
        \(data.prettyPrinted)
        """
    }

    static func createResponseString(_ error: Error, data: Data?, response: HTTPURLResponse?) -> String {
        """
        ----- URL -----
        \(response?.url!.absoluteString ?? "nil")
        --- Status ----
        \(response?.statusCode ?? 1)
        --- Headers ---
        \((response?.allHeaderFields as? [String: String])?.prettyPrinted ?? "nil")
        ---- Error ----
        \(error)
        ---- Body -----
        \(data?.prettyPrinted ?? "nil")
        """
    }
}

#if DEBUG
extension Stub {
    class StubNetworkService: NetworkService {}
}
#endif
