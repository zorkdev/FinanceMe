import Combine

public class LoginViewModel: ObservableObject {
    private let businessLogic: SessionBusinessLogicType
    private let loadingState: LoadingState
    private let errorViewModel: ErrorViewModel
    private var cancellables: Set<AnyCancellable> = []

    @Published public var email: String = ""
    @Published public var password: String = ""
    @Published public var isDisabled = true
    @Published public var isLoading = false

    public init(businessLogic: SessionBusinessLogicType,
                loadingState: LoadingState,
                errorViewModel: ErrorViewModel) {
        self.businessLogic = businessLogic
        self.loadingState = loadingState
        self.errorViewModel = errorViewModel
        setupBindings()
    }

    func onTap() {
        isLoading = true

        businessLogic.login(credentials: Credentials(email: email, password: password))
            .handleResult(loadingState: loadingState, errorViewModel: errorViewModel, cancellables: &cancellables)
    }

    private func setupBindings() {
        Publishers.CombineLatest($email, $password)
            .map { $0.isEmpty || $1.isEmpty }
            .receive(on: DispatchQueue.main)
            .assign(to: \.isDisabled, on: self)
            .store(in: &cancellables)
    }
}
