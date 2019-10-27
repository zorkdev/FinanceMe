import SwiftUI

public struct AmountView: View {
    private let viewModel: AmountViewModel
    private let isLargeDisplay: Bool

    public var body: some View {
        (smallText(viewModel.sign)
            + smallText(viewModel.currencySymbol)
            + largeText(viewModel.integer)
            + smallText(viewModel.decimalSeparator)
            + smallText(viewModel.fraction))
            .foregroundColor(viewModel.color)
    }

    public init(viewModel: AmountViewModel, isLargeDisplay: Bool = false) {
        self.viewModel = viewModel
        self.isLargeDisplay = isLargeDisplay
    }

    private func smallText(_ content: String) -> Text {
        Text(content).font(.system(.callout, design: .rounded))
    }

    private func largeText(_ content: String) -> Text {
        Text(content).font(.system(isLargeDisplay ? .largeTitle : .title, design: .rounded))
    }
}

#if DEBUG
// swiftlint:disable unused_declaration
struct AmountViewPreviews: PreviewProvider {
    static var previews: some View {
        AmountView(viewModel: AmountViewModel(value: 12.34))
            .previewLayout(.sizeThatFits)
    }
}
#endif
