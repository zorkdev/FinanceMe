import SwiftUI

public struct TodayView: View {
    @ObservedObject private var viewModel: TodayViewModel

    public var body: some View {
        VStack {
            VStack {
                AmountView(viewModel: viewModel.balance, isLargeDisplay: true)
                Text("BALANCE").font(.caption)
            }
            .accessibilityElement(children: .combine)
            Text("😨").font(.largeTitle)
            VStack {
                AmountView(viewModel: viewModel.allowance, isLargeDisplay: true)
                Text("ALLOWANCE").font(.caption)
            }
            .accessibilityElement(children: .combine)
        }
        .onAppear(perform: viewModel.onAppear)
        .onTapGesture(perform: viewModel.onAppear)
    }

    public init(appState: AppState) {
        self.viewModel = TodayViewModel(businessLogic: appState.userBusinessLogic)
    }
}

#if DEBUG
// swiftlint:disable unused_declaration
struct TodayViewPreviews: PreviewProvider {
    static var previews: some View {
        TodayView(appState: AppState.stub)
            .previewLayout(.sizeThatFits)
    }
}
#endif
