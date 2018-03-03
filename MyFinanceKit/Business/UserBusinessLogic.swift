public struct UserBusinessLogic {

    private let networkService: NetworkServiceType
    private let dataService: DataService

    public init(networkService: NetworkServiceType,
                dataService: DataService) {
        self.networkService = networkService
        self.dataService = dataService
    }

    public func getSession(credentials: Credentials) -> Promise<Session> {
        return networkService.performRequest(api: API.zorkdev(.login),
                                             method: .post,
                                             parameters: nil,
                                             body: credentials)
            .then { (session: Session) -> Promise<Session> in
                session.save(dataService: self.dataService)

                return .value(session)
        }
    }

    public func getCurrentUser() -> Promise<User> {
        return networkService.performRequest(api: API.zorkdev(.user),
                                             method: .get,
                                             parameters: nil,
                                             body: nil)
            .then { (user: User) -> Promise<User> in
                user.save(dataService: self.dataService)

                return .value(user)
        }
    }

    public func update(user: User) -> Promise<User> {
        return networkService.performRequest(api: API.zorkdev(.user),
                                             method: .patch,
                                             parameters: nil,
                                             body: user)
            .then { (user: User) -> Promise<User> in
                user.save(dataService: self.dataService)

                return .value(user)
        }
    }

}
