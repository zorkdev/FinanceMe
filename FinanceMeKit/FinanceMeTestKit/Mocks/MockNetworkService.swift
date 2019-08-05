import Combine
import FinanceMeKit

public class MockNetworkService: NetworkService {
    // swiftlint:disable large_tuple
    public var lastPerformParams: (api: APIType, method: HTTPMethod, body: Encodable?)?
    public var performReturnValues = [Result<Data, Error>]()

    public init() {}

    public func perform(api: APIType, method: HTTPMethod, body: Encodable?) -> AnyPublisher<Data, Error> {
        lastPerformParams = (api: api, method: method, body: body)
        return Result.Publisher(performReturnValues.removeFirst()).eraseToAnyPublisher()
    }
}
