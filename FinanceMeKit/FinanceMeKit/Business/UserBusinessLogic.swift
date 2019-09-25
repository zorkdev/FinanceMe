import Combine

public protocol UserBusinessLogicType {
    var user: AnyPublisher<User?, Never> { get }
    func getUser() -> AnyPublisher<Void, Error>
    func update(user: User) -> AnyPublisher<Void, Error>
}

class UserBusinessLogic: UserBusinessLogicType {
    private let networkService: NetworkService
    private let dataService: DataService

    @Published private var internalUser: User?

    var user: AnyPublisher<User?, Never> { $internalUser.eraseToAnyPublisher() }

    init(networkService: NetworkService, dataService: DataService) {
        self.networkService = networkService
        self.dataService = dataService
        self.internalUser = User.load(dataService: dataService)
    }

    func getUser() -> AnyPublisher<Void, Error> {
        networkService
            .perform(api: API.user,
                     method: .get,
                     body: nil)
            .tryMap { (user: User) in
                if case .failure(let error) = user.save(dataService: self.dataService) { throw error }
                self.internalUser = user
            }.eraseToAnyPublisher()
    }

    func update(user: User) -> AnyPublisher<Void, Error> {
        networkService
            .perform(api: API.user,
                     method: .patch,
                     body: user)
            .tryMap { (user: User) in
                if case .failure(let error) = user.save(dataService: self.dataService) { throw error }
                self.internalUser = user
            }.eraseToAnyPublisher()
    }
}

#if DEBUG
extension Stub {
    class StubUserBusinessLogic: UserBusinessLogicType {
        let user: AnyPublisher<User?, Never> = Just(User(
            name: "Name",
            payday: 10,
            startDate: ISO8601DateFormatter().date(from: "2019-01-01T00:00:00Z")!,
            largeTransaction: 10,
            allowance: 100.22,
            balance: 211.20)).eraseToAnyPublisher()
        func getUser() -> AnyPublisher<Void, Error> { Empty().eraseToAnyPublisher() }
        func update(user: User) -> AnyPublisher<Void, Error> { Empty().eraseToAnyPublisher() }
    }
}
#endif
