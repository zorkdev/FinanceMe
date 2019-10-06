import ClockKit
import WatchKit
import Combine
import FinanceMeKit

class ComplicationController: NSObject, CLKComplicationDataSource {
    private var cancellables: Set<AnyCancellable> = []

    func getSupportedTimeTravelDirections(for complication: CLKComplication,
                                          withHandler handler: @escaping (CLKComplicationTimeTravelDirections) -> Void) {
        handler([])
    }

    func getPrivacyBehavior(for complication: CLKComplication,
                            withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        handler(.hideOnLockScreen)
    }

    func getCurrentTimelineEntry(for complication: CLKComplication,
                                 withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        guard let appState = (WKExtension.shared().delegate as? ExtensionDelegate)?.appState else {
            handler(nil)
            return
        }

        appState.userBusinessLogic.user
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

    private func createComplicationTemplate(family: CLKComplicationFamily,
                                            allowance: Decimal) -> CLKComplicationTemplate? {
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
