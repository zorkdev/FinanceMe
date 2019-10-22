import Combine
import FinanceMeKit

public class MockSummaryBusinessLogic: SummaryBusinessLogicType {
    @Published public var summaryReturnValue: Summary?
    public var summary: AnyPublisher<Summary?, Never> { $summaryReturnValue.eraseToAnyPublisher() }

    public init() {}

    public var didCallFetchSummary = false
    public func fetchSummary() {
        didCallFetchSummary = true
    }

    public var didCallGetSummary = false
    public var getSummaryReturnValue: Result<Void, Error>?
    public func getSummary() -> AnyPublisher<Void, Error> {
        didCallGetSummary = true
        let returnValue = getSummaryReturnValue ?? .failure(NoReturnValueProviderError(function: #function))
        return returnValue.publisher.eraseToAnyPublisher()
    }
}
