import Combine
import MetricKit

protocol MetricManager {
    func add(_ subscriber: MXMetricManagerSubscriber)
}

extension MXMetricManager: MetricManager {}

protocol MetricService {}

final class DefaultMetricService: NSObject, MetricService {
    private let networkService: NetworkService
    private var cancellables: Set<AnyCancellable> = []

    init(networkService: NetworkService, metricManager: MetricManager) {
        self.networkService = networkService
        super.init()
        metricManager.add(self)
    }

    private func handle(payloads: [MXMetricPayload]) {
        payloads
            .map { $0.jsonRepresentation() }
            .forEach { data in
                networkService
                    .perform(api: API.metrics,
                             method: .post,
                             body: data)
                    .receive(on: DispatchQueue.global(qos: .background))
                    .sink(receiveCompletion: { _ in }, receiveValue: { _ in })
                    .store(in: &cancellables)
            }
    }
}

extension DefaultMetricService: MXMetricManagerSubscriber {
    func didReceive(_ payloads: [MXMetricPayload]) {
        handle(payloads: payloads)
    }
}

#if DEBUG
extension Stub {
    final class StubMetricService: MetricService {}
}
#endif
