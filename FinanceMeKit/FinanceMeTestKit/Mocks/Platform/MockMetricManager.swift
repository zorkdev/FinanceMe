import MetricKit
@testable import FinanceMeKit

public final class MockMetricManager: MetricManager {
    public init() {}

    public var lastAddParam: MXMetricManagerSubscriber?
    public func add(_ subscriber: MXMetricManagerSubscriber) {
        lastAddParam = subscriber
    }
}
