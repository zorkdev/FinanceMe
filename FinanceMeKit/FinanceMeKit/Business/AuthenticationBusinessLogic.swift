import Combine

public protocol AuthenticationBusinessLogicType {
    var isAuthenticated: AnyPublisher<Bool, Never> { get }
    func authenticate()
}

class AuthenticationBusinessLogic: AuthenticationBusinessLogicType {
    private static let reason = "Please authenticate to unlock this app."

    private let authenticationService: AuthenticationService
    private var cancellables: Set<AnyCancellable> = []

    @Published private var internalIsAuthenticated: Bool = false

    var isAuthenticated: AnyPublisher<Bool, Never> { $internalIsAuthenticated.eraseToAnyPublisher() }

    init(authenticationService: AuthenticationService) {
        self.authenticationService = authenticationService
    }

    func authenticate() {
        authenticationService.authenticate(reason: Self.reason)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure = completion { self.internalIsAuthenticated = false }
            }, receiveValue: {
                self.internalIsAuthenticated = true
            })
            .store(in: &cancellables)
    }
}

#if DEBUG
extension Stub {
    class StubAuthenticationBusinessLogic: AuthenticationBusinessLogicType {
        let isAuthenticated: AnyPublisher<Bool, Never> = Just(true).eraseToAnyPublisher()
        func authenticate() {}
    }
}
#endif
