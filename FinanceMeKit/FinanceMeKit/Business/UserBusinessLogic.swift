import Combine

public protocol UserBusinessLogicType {
    func login(credentials: Credentials) -> AnyPublisher<Void, Error>
    func getUser() -> AnyPublisher<User, Error>
    func update(user: User) -> AnyPublisher<User, Error>
}

public struct UserBusinessLogic: UserBusinessLogicType, ServiceClient {
    public let serviceProvider: NetworkServiceProvider & DataServiceProvider & SessionServiceProvider

    public init(serviceProvider: ServiceProvider) {
        self.serviceProvider = serviceProvider
    }

    public func login(credentials: Credentials) -> AnyPublisher<Void, Error> {
        serviceProvider.networkService
            .perform(api: ZorkdevAPI.login,
                     method: .post,
                     body: credentials)
            .map { (session: Session) in
                self.serviceProvider.sessionService.save(session: session)
            }.eraseToAnyPublisher()
    }

    public func getUser() -> AnyPublisher<User, Error> {
        serviceProvider.networkService
            .perform(api: ZorkdevAPI.user,
                     method: .get,
                     body: nil)
            .map { (user: User) in
                user.save(dataService: self.serviceProvider.dataService)
                return user
            }.eraseToAnyPublisher()
    }

    public func update(user: User) -> AnyPublisher<User, Error> {
        serviceProvider.networkService
            .perform(api: ZorkdevAPI.user,
                     method: .patch,
                     body: user)
            .map { (user: User) in
                user.save(dataService: self.serviceProvider.dataService)
                return user
            }.eraseToAnyPublisher()
    }
}
