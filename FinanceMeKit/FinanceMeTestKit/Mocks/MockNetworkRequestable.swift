import Combine
import FinanceMeKit

public class MockNetworkRequestable: NetworkRequestable {
    public var lastRequest: URLRequest?
    public var returnDataValue: Data?
    public var returnErrorValue: URLError?
    public var returnURLResponseValue: URLResponse?

    public init() {}

    public func perform(request: URLRequest) -> AnyPublisher<(data: Data, response: URLResponse), URLError> {
        lastRequest = request

        if let error = returnErrorValue {
            return Fail(error: error).eraseToAnyPublisher()
        }

        guard let returnDataValue = returnDataValue, let returnURLResponseValue = returnURLResponseValue else {
            return Fail(error: URLError(.cannotConnectToHost)).eraseToAnyPublisher()
        }
        return Result.Publisher((returnDataValue, returnURLResponseValue)).eraseToAnyPublisher()
    }
}
