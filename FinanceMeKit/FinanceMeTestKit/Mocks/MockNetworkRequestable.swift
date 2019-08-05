import Combine
import FinanceMeKit

public class MockNetworkRequestable: NetworkRequestable {
    public var lastPerformParam: URLRequest?
    public var performReturnValue: Result<(data: Data, response: URLResponse), URLError>?

    public init() {}

    public func perform(request: URLRequest) -> AnyPublisher<(data: Data, response: URLResponse), URLError> {
        lastPerformParam = request
        let returnValue = self.performReturnValue ?? .failure(URLError(.cannotConnectToHost))
        return Result.Publisher(returnValue).eraseToAnyPublisher()
    }
}
