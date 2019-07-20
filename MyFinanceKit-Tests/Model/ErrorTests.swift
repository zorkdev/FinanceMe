import PromiseKit
@testable import MyFinanceKit

class ErrorTests: XCTestCase {
    private func createPMKHTTPError(with statusCode: Int) -> PMKHTTPError {
        let url = URL(string: "http://www.test.com")!
        let httpURLResponse = HTTPURLResponse(url: url,
                                              statusCode: statusCode,
                                              httpVersion: nil,
                                              headerFields: nil)!
        return PMKHTTPError.badStatusCode(statusCode,
                                          Data(),
                                          httpURLResponse)
    }

    func testAppErrorLocalizedDescription() {
        XCTAssertNotNil(AppError.apiPathInvalid.localizedDescription)
    }

    func testApiErrorLocalizedDescription() {
        XCTAssertNotNil(APIError.badRequest.localizedDescription)
    }

    func testAPIErrorBadRequest() {
        let pmkHTTPError = createPMKHTTPError(with: 400)
        let apiError = APIError(httpError: pmkHTTPError)

        XCTAssertNotNil(apiError)
        XCTAssertEqual(apiError, APIError.badRequest)
    }

    func testAPIErrorUnauthorized() {
        let pmkHTTPError = createPMKHTTPError(with: 401)
        let apiError = APIError(httpError: pmkHTTPError)

        XCTAssertNotNil(apiError)
        XCTAssertEqual(apiError, APIError.unauthorized)
    }

    func testAPIErrorForbidden() {
        let pmkHTTPError = createPMKHTTPError(with: 403)
        let apiError = APIError(httpError: pmkHTTPError)

        XCTAssertNotNil(apiError)
        XCTAssertEqual(apiError, APIError.forbidden)
    }

    func testAPIErrorNotFound() {
        let pmkHTTPError = createPMKHTTPError(with: 404)
        let apiError = APIError(httpError: pmkHTTPError)

        XCTAssertNotNil(apiError)
        XCTAssertEqual(apiError, APIError.notFound)
    }

    func testAPIErrorFailure() {
        let pmkHTTPError = createPMKHTTPError(with: 666)
        let apiError = APIError(httpError: pmkHTTPError)

        XCTAssertNil(apiError)
    }

    func testAPIErrorServerError() {
        let pmkHTTPError = createPMKHTTPError(with: 500)
        let apiError = APIError(httpError: pmkHTTPError)

        XCTAssertNotNil(apiError)
        XCTAssertEqual(apiError, APIError.serverError)
    }
}
