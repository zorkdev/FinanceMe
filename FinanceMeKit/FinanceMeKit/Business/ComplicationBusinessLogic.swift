import Combine
import ClockKit

protocol ComplicationBusinessLogicType {}

final class ComplicationBusinessLogic: ComplicationBusinessLogicType {
    private let businessLogic: UserBusinessLogicType
    private var cancellables: Set<AnyCancellable> = []

    init(businessLogic: UserBusinessLogicType) {
        self.businessLogic = businessLogic
        setupBindings()
    }

    private func setupBindings() {
        businessLogic.user
            .receive(on: DispatchQueue.main)
            .sink { _ in self.updateComplications() }
            .store(in: &cancellables)
    }

    private func updateComplications() {
        let complicationServer = CLKComplicationServer.sharedInstance()
        guard let activeComplications = complicationServer.activeComplications else { return }
        activeComplications.forEach { complicationServer.reloadTimeline(for: $0) }
    }
}

#if DEBUG
extension Stub {
    final class StubComplicationBusinessLogic: ComplicationBusinessLogicType {}
}
#endif
