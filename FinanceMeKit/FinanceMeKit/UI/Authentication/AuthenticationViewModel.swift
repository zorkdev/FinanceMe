import Combine

public class AuthenticationViewModel: ObservableObject {
    private let businessLogic: AuthenticationBusinessLogicType
    private var cancellables: Set<AnyCancellable> = []

    @Published public var isAuthenticated: Bool = false

    public init(businessLogic: AuthenticationBusinessLogicType) {
        self.businessLogic = businessLogic
        setupBindings()
    }

    func onAppear() {
        businessLogic.authenticate()
    }

    private func setupBindings() {
        businessLogic.isAuthenticated
            .receive(on: DispatchQueue.main)
            .assign(to: \.isAuthenticated, on: self)
            .store(in: &cancellables)
    }
}
