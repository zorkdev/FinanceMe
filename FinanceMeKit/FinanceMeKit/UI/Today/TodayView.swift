import SwiftUI

public struct TodayView<ViewModel: TodayViewModelType>: View {
    @ObservedObject private var viewModel: ViewModel

    public var body: some View {
        HStack {
            VStack(alignment: .leading) {
                AmountView(viewModel: viewModel.balance)
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                Text("BALANCE").font(.caption)
            }
            Text("😨").font(.largeTitle)
            VStack(alignment: .trailing) {
                AmountView(viewModel: viewModel.allowance)
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
                Text("ALLOWANCE").font(.caption)
            }
        }
        .padding()
        .onAppear { self.viewModel.onAppear() }
    }

    public init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
}

#if DEBUG
struct TodayViewPreviews: PreviewProvider {
    class Stub: TodayViewModelType {
        var allowance = AmountViewModel(value: 10)
        var balance = AmountViewModel(value: 200)
        func onAppear() {}
    }

    static var previews: some View {
        TodayView(viewModel: Stub())
            .previewLayout(.sizeThatFits)
    }
}
#endif
