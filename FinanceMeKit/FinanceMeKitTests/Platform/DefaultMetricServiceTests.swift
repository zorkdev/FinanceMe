import XCTest
import MetricKit
import FinanceMeTestKit
@testable import FinanceMeKit

final class DefaultMetricServiceTests: XCTestCase {
    var networkService: MockNetworkService!
    var metricManager: MockMetricManager!
    var metricService: DefaultMetricService!

    override func setUp() {
        super.setUp()
        networkService = MockNetworkService()
        metricManager = MockMetricManager()
        metricService = DefaultMetricService(networkService: networkService, metricManager: metricManager)
    }

    func testInit() {
        XCTAssertTrue(metricManager.lastAddParam is DefaultMetricService)
    }

    func testDidReceive() {
        let payload = MXMetricPayload()
        networkService.performReturnValues = [.success(Data())]

        metricService.didReceive([payload])

        waitForEvent {}

        XCTAssertEqual(networkService.lastPerformParams?.api as? API, .metrics)
        XCTAssertEqual(networkService.lastPerformParams?.method, .post)
        XCTAssertEqual(networkService.lastPerformParams?.body as? Data, payload.jsonRepresentation())
    }
}
