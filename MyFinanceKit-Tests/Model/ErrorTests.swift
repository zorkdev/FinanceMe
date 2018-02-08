import PromiseKit
@testable import MyFinanceKit

class ErrorTests: XCTestCase {

    func testAPIErrorBadRequest() {
        let pmkURLError = createPMKURLError(with: 400)
        let apiError = APIError(urlError: pmkURLError)

        XCTAssertNotNil(apiError)
        XCTAssertEqual(apiError, APIError.badRequest)
    }

    func testAPIErrorUnauthorized() {
        let pmkURLError = createPMKURLError(with: 401)
        let apiError = APIError(urlError: pmkURLError)

        XCTAssertNotNil(apiError)
        XCTAssertEqual(apiError, APIError.unauthorized)
    }

    func testAPIErrorForbidden() {
        let pmkURLError = createPMKURLError(with: 403)
        let apiError = APIError(urlError: pmkURLError)

        XCTAssertNotNil(apiError)
        XCTAssertEqual(apiError, APIError.forbidden)
    }

    func testAPIErrorNotFound() {
        let pmkURLError = createPMKURLError(with: 404)
        let apiError = APIError(urlError: pmkURLError)

        XCTAssertNotNil(apiError)
        XCTAssertEqual(apiError, APIError.notFound)
    }

    func testAPIErrorFailure() {
        let pmkURLError = createPMKURLError(with: 666)
        let apiError = APIError(urlError: pmkURLError)

        XCTAssertNil(apiError)
    }

    func testAPIErrorServerError() {
        let pmkURLError = createPMKURLError(with: 500)
        let apiError = APIError(urlError: pmkURLError)

        XCTAssertNotNil(apiError)
        XCTAssertEqual(apiError, APIError.serverError)
    }

    private func createPMKURLError(with statusCode: Int) -> PMKURLError {
        let url = URL(string: "http://www.test.com")!
        let urlRequest = URLRequest(url: url)
        let httpURLResponse = HTTPURLResponse(url: url,
                                              statusCode: statusCode,
                                              httpVersion: nil,
                                              headerFields: nil)!
        return PMKURLError.badResponse(urlRequest,
                                       nil,
                                       httpURLResponse)
    }

}
