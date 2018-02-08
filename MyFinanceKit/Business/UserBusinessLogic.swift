public struct UserBusinessLogic {

    public init() {}

    public func getCurrentUser() -> Promise<User> {
        guard let url = ZorkdevAPI.user.url else {
            return Promise(error: AppError.apiPathInvalid)
        }

        return NetworkManager.shared.performRequest(api: .zorkdev,
                                                    method: .get,
                                                    url: url)
            .then { data in
                guard let user = User(data: data) else {
                    return Promise(error: AppError.jsonParsingError)
                }

                DataManager.shared.user = user

                return Promise(value: user)
        }
    }

}
