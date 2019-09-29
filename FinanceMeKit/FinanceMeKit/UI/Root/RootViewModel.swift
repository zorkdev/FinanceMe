import Combine

public class RootViewModel: ObservableObject {
    private let businessLogic: SessionBusinessLogicType
    private var cancellables: Set<AnyCancellable> = []

    @Published public var isLoggedIn = true

    public init(businessLogic: SessionBusinessLogicType) {
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
