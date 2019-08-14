@testable import FinanceMeKit

public class MockLoggingService: LoggingService {
    public init() {}

    // swiftlint:disable large_tuple
    public var lastLogParams: (title: String, content: String, type: LogType)?
    public func log(title: String, content: String, type: LogType) {
        lastLogParams = (title, content, type)
    }
}
