import Combine

final class TodayViewModel: ObservableObject {
    private let businessLogic: UserBusinessLogicType
    private let spendingBusinessLogic = SpendingBusinessLogic()
    private var cancellables: Set<AnyCancellable> = []

    @Published private(set) var balance = AmountViewModel(value: 0)
    @Published private(set) var allowance = AmountViewModel(value: 0)
    @Published private(set) var icon = ""

    init(businessLogic: UserBusinessLogicType) {
        self.businessLogic = businessLogic
        setupBindings()
    }

    func onAppear() {
        businessLogic.fetchUser()
    }

    private func setupBindings() {
        businessLogic.user
            .compactMap { $0?.balance }
            .map { AmountViewModel(value: $0) }
            .receive(on: DispatchQueue.main)
            .assign(to: \.balance, on: self)
            .store(in: &cancellables)

        businessLogic.user
            .compactMap { $0?.allowance }
            .map { AmountViewModel(value: $0) }
            .receive(on: DispatchQueue.main)
            .assign(to: \.allowance, on: self)
            .store(in: &cancellables)

        businessLogic.user
            .compactMap { $0 }
            .map { self.spendingBusinessLogic.icon(for: $0.allowance) }
            .receive(on: DispatchQueue.main)
            .assign(to: \.icon, on: self)
            .store(in: &cancellables)
    }
}
