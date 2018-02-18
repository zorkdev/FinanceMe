@testable import MyFinanceKit

class NetworkServiceTests: XCTestCase {

    func testPerformRequest() {
        let newExpectation = expectation(description: "Network call successful")

        _ = NetworkService.shared.performRequest(api: API.zorkdev(.endOfMonthSummaries),
                                                 method: .get,
                                                 parameters: nil,
                                                 body: nil)
            .done { data in
                newExpectation.fulfill()
        }

        waitForExpectations(timeout: 10.0, handler: nil)
    }

    func testPrintRequest() {
        let url = URL(string: "https://www.apple.com")!
        let request = URLRequest(url: url)

        let string = NetworkService.shared.createRequestString(request)
        let expectedValue =
        """
        ********** API Request **********
        GET https://www.apple.com
        --- Headers ---
        nil
        ---- Body -----
        nil
        *********************************

        """

        XCTAssertEqual(string, expectedValue)
    }

    func testPrintDataResponse() {
        let data =
        """
        {
          "key" : "value"
        }
        """.data(using: .utf8)!

        let string = NetworkService.shared.createResponseString(data)
        let expectedValue =
        """
        ********** API Response *********
        {
          "key" : "value"
        }
        *********************************

        """

        XCTAssertEqual(string, expectedValue)
    }

    func testPrintErrorResponse() {
        let error = NSError(domain: NSURLErrorDomain,
                            code: URLError.notConnectedToInternet.rawValue,
                            userInfo: nil)

        let string = NetworkService.shared.createResponseString(error)
        let expectedValue =
        """
        ********** API Error ***********
        Error Domain=NSURLErrorDomain Code=-1009 "(null)"
        *********************************

        """

        XCTAssertEqual(string, expectedValue)
    }

}
