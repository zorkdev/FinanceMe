public struct UserBusinessLogic {

    public init() {}

    public func getCurrentUser() -> Promise<User> {
        return NetworkService.shared.performRequest(api: .zorkdev(.user),
                                                    method: .get)
            .then { (user: User) -> Promise<User> in
                WatchManager.shared.updateComplication(allowance: user.allowance)
                user.save()

                return .value(user)
        }
    }

    public func update(user: User) -> Promise<User> {
        return NetworkService.shared.performRequest(api: .zorkdev(.user),
                                                    method: .patch,
                                                    body: user)
            .then { (user: User) -> Promise<User> in
                WatchManager.shared.updateComplication(allowance: user.allowance)
                user.save()

                return .value(user)
        }
    }

}
