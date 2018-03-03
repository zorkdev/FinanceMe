public struct UserBusinessLogic {

    private let networkService: NetworkServiceType
    private let dataService: DataService

    public init(networkService: NetworkServiceType,
                dataService: DataService) {
        self.networkService = networkService
        self.dataService = dataService
    }

    public func getLogin(email: String, password: String) -> Promise<Session> {
        let credentials = CredentialsParameters(email: email, password: password)

        return networkService.performRequest(api: API.zorkdev(.login),
                                             method: .get,
                                             parameters: credentials,
                                             body: nil)
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
