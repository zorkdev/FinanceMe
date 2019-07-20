public struct UserBusinessLogic: ServiceClient {
    public typealias ServiceProvider = NetworkServiceProvider & DataServiceProvider & SessionServiceProvider
    public let serviceProvider: ServiceProvider

    public init(serviceProvider: ServiceProvider) {
        self.serviceProvider = serviceProvider
    }

    public func getSession(credentials: Credentials) -> Promise<Session> {
        return serviceProvider.networkService
            .performRequest(api: API.zorkdev(.login),
                            method: .post,
                            parameters: nil,
                            body: credentials)
            .then { (session: Session) -> Promise<Session> in
                self.serviceProvider.sessionService.save(session: session)

                return .value(session)
            }
    }

    public func getCurrentUser() -> Promise<User> {
        return serviceProvider.networkService
            .performRequest(api: API.zorkdev(.user),
                            method: .get,
                            parameters: nil,
                            body: nil)
            .then { (user: User) -> Promise<User> in
                user.save(dataService: self.serviceProvider.dataService)

                return .value(user)
            }
    }

    public func update(user: User) -> Promise<User> {
        return serviceProvider.networkService
            .performRequest(api: API.zorkdev(.user),
                            method: .patch,
                            parameters: nil,
                            body: user)
            .then { (user: User) -> Promise<User> in
                user.save(dataService: self.serviceProvider.dataService)

                return .value(user)
            }
    }
}
