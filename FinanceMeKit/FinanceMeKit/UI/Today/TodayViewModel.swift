import Combine

public class TodayViewModel: ObservableObject {
    private let businessLogic: UserBusinessLogicType
    private let spendingBusinessLogic = SpendingBusinessLogic()
    private var cancellables: Set<AnyCancellable> = []

    @Published public private(set) var balance = AmountViewModel(value: 0)
    @Published public private(set) var allowance = AmountViewModel(value: 0)
    @Published public private(set) var icon = ""

    public init(businessLogic: UserBusinessLogicType) {
        self.businessLogic = businessLogic
        setupBindings()
    }

    public func onAppear() {
        updateUser()
    }

    private func setupBindings() {
        businessLogic.user
            .map { AmountViewModel(value: $0?.balance ?? 0) }
            .receive(on: DispatchQueue.main)
            .assign(to: \.balance, on: self)
            .store(in: &cancellables)

        businessLogic.user
            .map { AmountViewModel(value: $0?.allowance ?? 0) }
            .receive(on: DispatchQueue.main)
            .assign(to: \.allowance, on: self)
            .store(in: &cancellables)

        businessLogic.user
            .map { $0.flatMap { self.spendingBusinessLogic.icon(for: $0.allowance) } ?? "" }
            .receive(on: DispatchQueue.main)
            .assign(to: \.icon, on: self)
            .store(in: &cancellables)
    }

    private func updateUser() {
        businessLogic.getUser()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: {})
            .store(in: &cancellables)
    }
}
