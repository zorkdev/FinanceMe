import WatchKit
import ClockKit
import FinanceMeKit

// swiftlint:disable unused_declaration
final class ComplicationController: NSObject, CLKComplicationDataSource {
    private let viewModel: ComplicationViewModel = {
        let appState = (WKExtension.shared().delegate as? ExtensionDelegate)!.appState
        return ComplicationViewModel(appState: appState)
    }()

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
        viewModel.getCurrentTimelineEntry(for: complication, withHandler: handler)
    }

    func getComplicationDescriptors(handler: @escaping ([CLKComplicationDescriptor]) -> Void) {
        let complication = CLKComplicationDescriptor(
            identifier: "FinanceMe",
            displayName: "FinanceMe",
            supportedFamilies: [
                .circularSmall,
                .extraLarge,
                .graphicBezel,
                .graphicCircular,
                .graphicCorner,
                .graphicExtraLarge,
                .graphicRectangular,
                .modularLarge,
                .modularSmall,
                .utilitarianLarge,
                .utilitarianSmall,
                .utilitarianSmallFlat
            ]
        )
        handler([complication])
    }
}
