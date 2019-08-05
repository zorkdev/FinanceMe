import Combine

public protocol NetworkServiceProvider {
    var networkService: NetworkService { get }
}

public enum HTTPMethod: String {
    case post = "POST"
    case get = "GET"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

public protocol APIType {
    var url: URL { get }
    func token(session: Session) -> String
}

public protocol NetworkRequestable {
    func perform(request: URLRequest) -> AnyPublisher<(data: Data, response: URLResponse), URLError>
}

public protocol NetworkService {
    func perform(api: APIType, method: HTTPMethod, body: Encodable?) -> AnyPublisher<Data, Error>
    func perform<T: Decodable>(api: APIType, method: HTTPMethod, body: Encodable?) -> AnyPublisher<T, Error>
}

public extension NetworkService {
    func perform<T: Decodable>(api: APIType, method: HTTPMethod, body: Encodable?) -> AnyPublisher<T, Error> {
        perform(api: api, method: method, body: body)
            .decode(type: T.self, decoder: JSONDecoder.default)
            .eraseToAnyPublisher()
    }
}

public class DefaultNetworkService: NetworkService {
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

    public init(networkRequestable: NetworkRequestable,
                loggingService: LoggingService,
                sessionService: SessionService) {
        self.networkRequestable = networkRequestable
        self.loggingService = loggingService
        self.sessionService = sessionService
    }

    public func perform(api: APIType, method: HTTPMethod, body: Encodable?) -> AnyPublisher<Data, Error> {
        let request: URLRequest
        switch createURLRequest(api: api, method: method, body: body) {
        case .success(let urlRequest): request = urlRequest
        case .failure(let error): return Fail(error: error).eraseToAnyPublisher()
        }

        loggingService.log(
            title: "API Request",
            content: Self.createRequestString(request))

        return networkRequestable.perform(request: request)
            .tryMap { response in
                guard let urlResponse = response.response as? HTTPURLResponse else {
                    let error = HTTPError(code: 1)!
                    self.loggingService.log(
                        title: "API Error",
                        content: Self.createResponseString(error, data: response.data, response: nil),
                        type: .error)
                    throw error
                }

                if let error = HTTPError(code: urlResponse.statusCode) {
                    self.loggingService.log(
                        title: "API Error",
                        content: Self.createResponseString(error, data: response.data, response: urlResponse),
                        type: .error)
                    throw error
                }

                self.loggingService.log(
                    title: "API Response",
                    content: Self.createResponseString(response.data, response: urlResponse))
                return response.data
            }.mapError { error in
                self.loggingService.log(
                    title: "API Error",
                    content: Self.createResponseString(error, data: nil, response: nil),
                    type: .error)
                return error
            }.eraseToAnyPublisher()
    }
}

private extension DefaultNetworkService {
    func createURLRequest(api: APIType, method: HTTPMethod, body: Encodable?) -> Result<URLRequest, Error> {
        var request = URLRequest(url: api.url)
        request.httpMethod = method.rawValue
        request.setValue(Constants.contentValue, forHTTPHeaderField: Constants.contentKey)
        request.setValue(Constants.contentValue, forHTTPHeaderField: Constants.contentTypeKey)

        switch body?.jsonEncoded() {
        case .success(let data): request.httpBody = data
        case .failure(let error): return .failure(error)
        case .none: break
        }

        if let session = sessionService.session {
            let token = api.token(session: session)
            request.setValue(Constants.authHeaderValue(token), forHTTPHeaderField: Constants.authHeaderKey)
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

    static func createResponseString(_ data: Data, response: HTTPURLResponse) -> String {
        """
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
