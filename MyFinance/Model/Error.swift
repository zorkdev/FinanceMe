#if os(macOS)
import Cocoa
import PromiseKit
#endif

enum AppError: Error {

    case unknownError
    case apiPathInvalid
    case urlQueryInvalid
    case jsonParsingError

}

enum APIError: Int, Error {

    case badRequest = 400
    case unauthorized = 401
    case forbidden = 403
    case notFound = 404
    case serverError = 500

    init?(urlError: PMKURLError) {
        guard case let .badResponse(_, _, response) = urlError,
            let urlResponse = response as? HTTPURLResponse,
            let apiError = APIError(rawValue: urlResponse.statusCode) else {
                return nil
        }

        self = apiError
    }

}
