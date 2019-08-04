import XCTest
import FinanceMeTestKit
@testable import FinanceMeKit

class DefaultLoggingServiceTests: XCTestCase {
    func testLogging() {
        let configService = MockConfigService()
        let loggingService = DefaultLoggingService(configService: configService)

        loggingService.log(title: "Title", content: "Content")
        loggingService.log(title: "Title", content: "Content", type: .error)

        XCTAssertEqual(
            DefaultLoggingService.createLogString(title: "Title", content: "Content", type: .info),
            """

            🔵 ********** Title *********
            Content
            *********************************

            """
        )
    }
}
