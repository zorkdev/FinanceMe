import XCTest
@testable import FinanceMeKit

final class DefaultConfigServiceTests: XCTestCase {
    func testInit() {
        let configService = DefaultConfigService()

        XCTAssertEqual(configService.productName, "com.zorkdev.FinanceMe")
        XCTAssertEqual(configService.accessGroup, "WX9VZ58J6W.com.zorkdev.FinanceMe")
    }
}
