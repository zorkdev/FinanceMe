import Combine

public class LoginViewModel: ObservableObject {
    private let businessLogic: SessionBusinessLogicType
    private var cancellables: Set<AnyCancellable> = []

    @Published public var email: String = ""
    @Published public var password: String = ""
    @Published public var isDisabled = true

    public init(businessLogic: SessionBusinessLogicType) {
        self.businessLogic = businessLogic
        setupBindings()
    }

    func onTap() {
        businessLogic.login(credentials: Credentials(email: email, password: password))
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: {})
            .store(in: &cancellables)
    }

    private func setupBindings() {
        Publishers.CombineLatest($email, $password)
            .map { $0.isEmpty || $1.isEmpty }
            .receive(on: DispatchQueue.main)
            .assign(to: \.isDisabled, on: self)
            .store(in: &cancellables)
    }
}
