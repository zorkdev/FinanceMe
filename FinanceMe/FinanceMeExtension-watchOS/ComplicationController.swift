import WatchKit
import FinanceMeKit

// swiftlint:disable unused_declaration
class ComplicationController: NSObject, CLKComplicationDataSource {
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
}
