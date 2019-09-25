import UIKit
import SwiftUI
import NotificationCenter
import FinanceMeKit

class TodayViewController: UIHostingController<AnyView>, NCWidgetProviding {
    private let appState = AppState()

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(rootView: AnyView(TodayContentView().environmentObject(appState)))
        view.backgroundColor = .clear
    }

    required init?(coder aDecoder: NSCoder) { return nil }

    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        print(AmountViewModel(value: Decimal(string: "10")!).string)
        completionHandler(.newData)
    }
}

struct TodayContentView: View {
    @EnvironmentObject private var appState: AppState

    var body: some View {
        TodayView(viewModel: TodayViewModel(businessLogic: appState.userBusinessLogic))
    }
}

#if DEBUG
struct TodayContentViewPreviews: PreviewProvider {
    static var previews: some View {
        TodayContentView().environmentObject(AppState.stub)
    }
}
#endif
