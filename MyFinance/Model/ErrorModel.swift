enum AppError: Error {

    case unknownError
    case tokenNotFound
    case apiPathInvalid
    case urlQueryInvalid

}

enum APIError: Int, Error {

    case badRequest = 400
    case unauthorized = 401
    case forbidden = 403
    case notFound = 404
    case serverError = 500

    init?(urlError: PMKURLError) {
        guard case let .badResponse(_, _, response) = urlError,
            let statusCode = (response as? HTTPURLResponse)?.statusCode,
            let apiError = APIError(rawValue: statusCode) else {
                return nil
        }
        self = apiError
    }

}
