import Combine

class BalancesViewModel: ObservableObject {
    struct Summary: Identifiable, Equatable {
        let summary: EndOfMonthSummary
        var narrative: String { Formatters.month.string(from: summary.created) }
        var amount: Decimal { summary.balance }
        var id: Date { summary.created }
    }

    private let businessLogic: SummaryBusinessLogicType
    private var cancellables: Set<AnyCancellable> = []

    @Published var currentMonth = CurrentMonthSummary(allowance: 0, forecast: 0, spending: 0)
    @Published var summarySections: [ListSection<Summary>] = []

    init(businessLogic: SummaryBusinessLogicType) {
        self.businessLogic = businessLogic
        setupBindings()
    }

    private func setupBindings() {
        setupCurrentMonth()
        setupSummarySections()
    }

    private func setupCurrentMonth() {
        businessLogic.summary
            .compactMap { $0?.currentMonthSummary }
            .receive(on: DispatchQueue.main)
            .assign(to: \.currentMonth, on: self)
            .store(in: &cancellables)
    }

    private func setupSummarySections() {
        businessLogic.summary
            .compactMap { $0?.endOfMonthSummaries }
            .map {
                $0.sorted { $0.created > $1.created }
                    .map { Summary(summary: $0) }
            }.map {
                Dictionary(grouping: $0) { Formatters.year.string(from: $0.summary.created) }
                    .sorted { $0.value[0].summary.created > $1.value[0].summary.created }
                .map { ListSection(title: $0.key, rows: $0.value) }
            }.receive(on: DispatchQueue.main)
            .assign(to: \.summarySections, on: self)
            .store(in: &cancellables)
    }
}
