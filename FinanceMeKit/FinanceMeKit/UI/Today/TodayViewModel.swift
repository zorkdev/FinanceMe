import Combine

public protocol TodayViewModelType: ObservableObject {
    var balance: AmountViewModel { get }
    var allowance: AmountViewModel { get }
    func onAppear()
}

public class TodayViewModel: TodayViewModelType {
    private let businessLogic: UserBusinessLogicType
    private var cancellables: Set<AnyCancellable> = []

    @Published public private(set) var balance = AmountViewModel(value: 0)
    @Published public private(set) var allowance = AmountViewModel(value: 0)

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
    }

    private func updateUser() {
        businessLogic.getUser()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: {})
            .store(in: &cancellables)
    }
}
