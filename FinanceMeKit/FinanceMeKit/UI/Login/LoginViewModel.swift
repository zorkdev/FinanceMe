import Combine

final class LoginViewModel: ObservableObject {
    private let businessLogic: SessionBusinessLogicType
    private let loadingState: LoadingState
    private let errorViewModel: ErrorViewModel
    private var cancellables: Set<AnyCancellable> = []

    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isDisabled = true

    init(businessLogic: SessionBusinessLogicType,
         loadingState: LoadingState,
         errorViewModel: ErrorViewModel) {
        self.businessLogic = businessLogic
        self.loadingState = loadingState
        self.errorViewModel = errorViewModel
        setupBindings()
    }

    func onTap() {
        loadingState.isLoading = true

        businessLogic.login(credentials: Credentials(email: email, password: password))
            .handleResult(loadingState: loadingState, errorViewModel: errorViewModel, cancellables: &cancellables)
    }
}

private extension LoginViewModel {
    func setupBindings() {
        Publishers.CombineLatest($email, $password)
            .map { $0.isEmpty || $1.isEmpty }
            .receive(on: DispatchQueue.main)
            .assign(to: \.isDisabled, on: self)
            .store(in: &cancellables)
    }
}
