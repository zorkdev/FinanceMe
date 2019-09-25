import Cocoa
import SwiftUI
import NotificationCenter
import FinanceMeKit

class TodayViewController: NSViewController, NCWidgetProviding {
    private let appState = AppState()

    override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        let todayView = NSHostingView(rootView: TodayContentView().environmentObject(appState))
        todayView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(todayView)

        NSLayoutConstraint.activate([
            todayView.topAnchor.constraint(equalTo: view.topAnchor),
            todayView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            todayView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            todayView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    @objc
    dynamic required init?(coder: NSCoder) { return nil }

    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
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
