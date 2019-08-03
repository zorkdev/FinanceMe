import XCTest
@testable import FinanceMeKit

class DefaultConfigServiceTests: XCTestCase {
    func testInit() {
        let configService = DefaultConfigService()

        XCTAssertEqual(configService.urlScheme, "urlscheme://")
        XCTAssertEqual(configService.productName, "com.zorkdev.FinanceMeKitTestsHost")
        XCTAssertEqual(configService.accessGroup, "WX9VZ58J6W.com.zorkdev.FinanceMeKitTestsHost")
    }
}
