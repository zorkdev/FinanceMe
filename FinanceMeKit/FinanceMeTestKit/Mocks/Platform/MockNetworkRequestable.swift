import Combine
@testable import FinanceMeKit

public class MockNetworkRequestable: NetworkRequestable {
    public init() {}

    public var lastPerformParam: URLRequest?
    public var performReturnValue: Result<(data: Data, response: URLResponse), URLError>?
    public func perform(request: URLRequest) -> AnyPublisher<(data: Data, response: URLResponse), URLError> {
        lastPerformParam = request
        let returnValue = self.performReturnValue ?? .failure(URLError(.cannotConnectToHost))
        return Result.Publisher(returnValue).eraseToAnyPublisher()
    }
}
