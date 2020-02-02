import ClockKit
import Combine

public final class ComplicationViewModel {
    private let businessLogic: UserBusinessLogicType
    private var cancellables: Set<AnyCancellable> = []

    public init(appState: AppState) {
        self.businessLogic = appState.userBusinessLogic
    }

    public func getCurrentTimelineEntry(for complication: CLKComplication,
                                        withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        businessLogic.user
            .receive(on: DispatchQueue.main)
            .sink { user in
                self.cancellables.forEach { $0.cancel() }

                guard let allowance = user?.allowance,
                    let template = self.createComplicationTemplate(family: complication.family, allowance: allowance) else {
                        handler(nil)
                        return
                }

                let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
                handler(timelineEntry)
            }.store(in: &cancellables)
    }
}

private extension ComplicationViewModel {
    func createComplicationTemplate(family: CLKComplicationFamily, allowance: Double) -> CLKComplicationTemplate? {
        let viewModel = AmountViewModel(value: allowance)

        switch family {
        case .utilitarianLarge:
            let template = CLKComplicationTemplateUtilitarianLargeFlat()
            template.textProvider = CLKSimpleTextProvider(text: viewModel.string)
            return template
        case .utilitarianSmallFlat:
            let template = CLKComplicationTemplateUtilitarianSmallFlat()
            template.textProvider = CLKSimpleTextProvider(text: viewModel.string)
            return template
        case .graphicCircular:
            let template = CLKComplicationTemplateGraphicCircularOpenGaugeSimpleText()
            template.centerTextProvider = CLKSimpleTextProvider(text: viewModel.integerString)
            template.bottomTextProvider = CLKSimpleTextProvider(text: viewModel.currencySymbol)
            template.gaugeProvider = CLKSimpleGaugeProvider(style: .fill,
                                                            gaugeColor: .white,
                                                            fillFraction: 0.5)
            return template
        default:
            return nil
        }
    }
}
