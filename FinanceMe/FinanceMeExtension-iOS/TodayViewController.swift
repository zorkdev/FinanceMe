import UIKit
import SwiftUI
import NotificationCenter
import FinanceMeKit

class TodayViewController: UIHostingController<TodayContentView<TodayViewModel>>, NCWidgetProviding {
    private let appState = AppState()

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(rootView: TodayContentView(viewModel: TodayViewModel(businessLogic: appState.userBusinessLogic)))
        view.backgroundColor = .clear
    }

    required init?(coder aDecoder: NSCoder) { return nil }

    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        print(AmountViewModel(value: Decimal(string: "10")!).string)
        completionHandler(.newData)
    }
}

struct TodayContentView<ViewModel: TodayViewModelType>: View {
    let viewModel: ViewModel

    var body: some View {
        TodayView(viewModel: viewModel)
    }
}

#if DEBUG
struct TodayContentViewPreviews: PreviewProvider {
    class Stub: TodayViewModelType {
        var allowance = AmountViewModel(value: 10)
        var balance = AmountViewModel(value: 200)
        func onAppear() {}
    }

    static var previews: some View {
        TodayContentView(viewModel: Stub())
    }
}
#endif
