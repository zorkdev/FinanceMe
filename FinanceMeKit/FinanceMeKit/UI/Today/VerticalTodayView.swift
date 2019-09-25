import SwiftUI

public struct VerticalTodayView<ViewModel: TodayViewModelType>: View {
    @ObservedObject private var viewModel: ViewModel

    public var body: some View {
        VStack {
            AmountView(viewModel: viewModel.balance)
            Text("BALANCE").font(.caption)
            Text("😨").font(.largeTitle)
            AmountView(viewModel: viewModel.allowance)
            Text("ALLOWANCE").font(.caption)
        }
        .onAppear { self.viewModel.onAppear() }
    }

    public init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
}

#if DEBUG
struct VerticalTodayViewPreviews: PreviewProvider {
    static var previews: some View {
        VerticalTodayView(viewModel: Stub.StubTodayViewModel())
            .previewLayout(.sizeThatFits)
    }
}
#endif
