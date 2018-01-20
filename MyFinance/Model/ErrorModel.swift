import Foundation

enum AppError: Error {

    case unknownError
    case tokenNotFound
    case apiPathInvalid
    case urlQueryInvalid

}

struct APIError: Error {

    let status: NetworkManager.HTTPStatus

}
