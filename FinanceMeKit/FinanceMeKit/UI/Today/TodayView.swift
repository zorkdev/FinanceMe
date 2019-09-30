import SwiftUI

public struct TodayView: View {
    @ObservedObject private var viewModel: TodayViewModel

    public var body: some View {
        HStack {
            VStack(alignment: .leading) {
                AmountView(viewModel: viewModel.balance)
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                Text("BALANCE").font(.caption).foregroundColor(Color.secondary)
            }
            Text(viewModel.icon).font(.largeTitle)
            VStack(alignment: .trailing) {
                AmountView(viewModel: viewModel.allowance)
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
                Text("ALLOWANCE").font(.caption).foregroundColor(Color.secondary)
            }
        }
        .padding()
        .onAppear(perform: viewModel.onAppear)
    }

    public init(appState: AppState) {
        self.viewModel = TodayViewModel(businessLogic: appState.userBusinessLogic)
    }
}

struct TodayViewPreviews: PreviewProvider {
    static var previews: some View {
        TodayView(appState: AppState.stub)
            .previewLayout(.sizeThatFits)
    }
}
