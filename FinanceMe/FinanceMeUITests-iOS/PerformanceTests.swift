import XCTest

final class PerformanceTests: XCTestCase {
    func testLaunchPerformance() {
        measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
            XCUIApplication().launch()
        }
    }
}
