import SwiftUI

public struct TodayView: View {
    @ObservedObject private var viewModel: TodayViewModel

    public var body: some View {
        VStack {
            AmountView(viewModel: viewModel.balance)
            Text("BALANCE").font(.caption)
            Text("😨").font(.largeTitle)
            AmountView(viewModel: viewModel.allowance)
            Text("ALLOWANCE").font(.caption)
        }
        .onAppear(perform: viewModel.onAppear)
        .onTapGesture(perform: viewModel.onAppear)
    }

    public init(appState: AppState) {
        self.viewModel = TodayViewModel(businessLogic: appState.userBusinessLogic)
    }
}

#if DEBUG
struct TodayViewPreviews: PreviewProvider {
    static var previews: some View {
        TodayView(appState: AppState.stub)
            .previewLayout(.sizeThatFits)
    }
}
#endif
