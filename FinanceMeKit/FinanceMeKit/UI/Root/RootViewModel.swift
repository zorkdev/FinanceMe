import Combine

final class RootViewModel: ObservableObject {
    private let businessLogic: SessionBusinessLogicType
    private var cancellables: Set<AnyCancellable> = []

    @Published var isLoggedIn: Bool

    init(service: SessionService, businessLogic: SessionBusinessLogicType) {
        self.businessLogic = businessLogic
        self.isLoggedIn = service.hasSession
        setupBindings()
    }
}

private extension RootViewModel {
    func setupBindings() {
        businessLogic.isLoggedIn
            .receive(on: DispatchQueue.main)
            .assign(to: \.isLoggedIn, on: self)
            .store(in: &cancellables)
    }
}
