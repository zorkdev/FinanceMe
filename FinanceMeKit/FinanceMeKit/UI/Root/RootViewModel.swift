import Combine

class RootViewModel: ObservableObject {
    private let businessLogic: SessionBusinessLogicType
    private var cancellables: Set<AnyCancellable> = []

    @Published var isLoggedIn = true

    init(businessLogic: SessionBusinessLogicType) {
        self.businessLogic = businessLogic
        setupBindings()
    }

    private func setupBindings() {
        businessLogic.isLoggedIn
            .receive(on: DispatchQueue.main)
            .assign(to: \.isLoggedIn, on: self)
            .store(in: &cancellables)
    }
}
