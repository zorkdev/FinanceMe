import Combine

public class HomeViewModel: ObservableObject {
    private let userBusinessLogic: UserBusinessLogicType
    private let transactionBusinessLogic: TransactionBusinessLogicType
    private let summaryBusinessLogic: SummaryBusinessLogicType
    private var cancellables: Set<AnyCancellable> = []

    public init(userBusinessLogic: UserBusinessLogicType,
                transactionBusinessLogic: TransactionBusinessLogicType,
                summaryBusinessLogic: SummaryBusinessLogicType) {
        self.userBusinessLogic = userBusinessLogic
        self.transactionBusinessLogic = transactionBusinessLogic
        self.summaryBusinessLogic = summaryBusinessLogic
    }

    func onAppear() {
        transactionBusinessLogic.fetchTransactions()
        summaryBusinessLogic.fetchSummary()
    }

    func onRefresh() {
        userBusinessLogic.getUser()
            .flatMap { self.transactionBusinessLogic.getTransactions() }
            .flatMap { self.summaryBusinessLogic.getSummary() }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: {})
            .store(in: &cancellables)
    }
}
