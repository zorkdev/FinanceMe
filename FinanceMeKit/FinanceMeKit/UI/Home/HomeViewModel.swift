public class HomeViewModel: ObservableObject {
    private let transactionBusinessLogic: TransactionBusinessLogicType
    private let summaryBusinessLogic: SummaryBusinessLogicType

    public init(transactionBusinessLogic: TransactionBusinessLogicType,
                summaryBusinessLogic: SummaryBusinessLogicType) {
        self.transactionBusinessLogic = transactionBusinessLogic
        self.summaryBusinessLogic = summaryBusinessLogic
    }

    func onAppear() {
        transactionBusinessLogic.fetchTransactions()
        summaryBusinessLogic.fetchSummary()
    }
}
