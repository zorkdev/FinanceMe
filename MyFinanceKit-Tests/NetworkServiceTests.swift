import PromiseKit
@testable import MyFinanceKit

//swiftlint:disable nesting
class NetworkServiceTests: XCTestCase {

    let mockNetworkRequestable = MockNetworkRequestable()
    let mockConfigService = MockConfigService()
    let mockAPI = MockAPI()

    func testPerformRequest() {
        let newExpectation = expectation(description: "Network call successful")

        let mockToken = mockAPI.token(config: mockConfigService.config)

        let networkService = NetworkService(networkRequestable: mockNetworkRequestable,
                                            configService: mockConfigService)

        _ = networkService.performRequest(api: mockAPI,
                                          method: .get,
                                          parameters: nil,
                                          body: nil)
            .done { _ in
                let request = self.mockNetworkRequestable.lastRequest!
                let headers = request.allHTTPHeaderFields!

                XCTAssertEqual(request.url, self.mockAPI.url!)
                XCTAssertEqual(request.httpMethod, HTTPMethod.get.rawValue)
                XCTAssertNil(request.httpBody)
                XCTAssertNil(request.url?.query)
                XCTAssertEqual(headers["Accept"], "application/json")
                XCTAssertEqual(headers["Accept-Encoding"], "gzip, deflate")
                XCTAssertEqual(headers["Authorization"], "Bearer \(mockToken)")
                XCTAssertNil(headers["Content-Type"])

                newExpectation.fulfill()
        }

        waitForExpectations(timeout: 10.0, handler: nil)
    }

    func testPerformRequestWithBodyAndParameters() {
        let newExpectation = expectation(description: "Network call successful")

        let mockToken = mockAPI.token(config: mockConfigService.config)

        let networkService = NetworkService(networkRequestable: mockNetworkRequestable,
                                            configService: mockConfigService)

        struct Body: JSONEncodable {
            let body = "body"
        }

        struct Parameters: JSONEncodable {
            let parameter = "parameter"
        }

        let body = Body()
        let parameters = Parameters()
        let expectedBody = "{\"body\":\"body\"}".data(using: .utf8)!
        let urlString = mockAPI.url!.absoluteString + "?parameter=parameter"
        let expectedURL = URL(string: urlString)!

        _ = networkService.performRequest(api: mockAPI,
                                          method: .get,
                                          parameters: parameters,
                                          body: body)
            .done { _ in
                let request = self.mockNetworkRequestable.lastRequest!
                let headers = request.allHTTPHeaderFields!

                XCTAssertEqual(request.url, expectedURL)
                XCTAssertEqual(request.httpMethod, HTTPMethod.get.rawValue)
                XCTAssertEqual(request.httpBody, expectedBody)
                XCTAssertEqual(request.url?.query, "parameter=parameter")
                XCTAssertEqual(headers["Accept"], "application/json")
                XCTAssertEqual(headers["Accept-Encoding"], "gzip, deflate")
                XCTAssertEqual(headers["Authorization"], "Bearer \(mockToken)")
                XCTAssertEqual(headers["Content-Type"], "application/json")

                newExpectation.fulfill()
        }

        waitForExpectations(timeout: 10.0, handler: nil)
    }

//    func testPerformRequestWithJSONCodable() {
//        let newExpectation = expectation(description: "Network call successful")
//
//        let mockToken = mockAPI.token(config: mockConfigService.config)
//
//        let networkService = NetworkService(networkRequestable: mockNetworkRequestable,
//                                            configService: mockConfigService)
//
//        struct Body: JSONEncodable {
//            let body = "body"
//        }
//
//        let body = Body()
//        let expectedBody = "{\"body\":\"body\"}".data(using: .utf8)!
//
//
//        let bodyPromise: () -> Promise<Body> = {
//            return networkService.performRequest(api: mockAPI,
//                                                 method: .get,
//                                                 parameters: nil,
//                                                 body: body)
//                .then { (body: Body) -> Promise<Body> in
//                    return .value(body)
//            }
//        }
////            .then { (body: Body) in
////                let request = self.mockNetworkRequestable.lastRequest!
////                let headers = request.allHTTPHeaderFields!
////
////                XCTAssertEqual(request.url, expectedURL)
////                XCTAssertEqual(request.httpMethod, HTTPMethod.get.rawValue)
////                XCTAssertEqual(request.httpBody, expectedBody)
////                XCTAssertEqual(request.url?.query, "parameter=parameter")
////                XCTAssertEqual(headers["Accept"], "application/json")
////                XCTAssertEqual(headers["Accept-Encoding"], "gzip, deflate")
////                XCTAssertEqual(headers["Authorization"], "Bearer \(mockToken)")
////                XCTAssertEqual(headers["Content-Type"], "application/json")
////
////                newExpectation.fulfill()
////        }
//
//        waitForExpectations(timeout: 10.0, handler: nil)
//    }

    func testPrintRequest() {
        let url = URL(string: "https://www.apple.com")!
        let request = URLRequest(url: url)

        let string = NetworkService.createRequestString(request)
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

        let string = NetworkService.createResponseString(data)
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

        let string = NetworkService.createResponseString(error)
        let expectedValue =
        """
        ********** API Error ***********
        Error Domain=NSURLErrorDomain Code=-1009 "(null)"
        *********************************

        """

        XCTAssertEqual(string, expectedValue)
    }

}
