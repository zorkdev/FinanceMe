import SwiftUI

public struct AmountView: View {
    private let viewModel: AmountViewModel

    public var body: some View {
        (smallText(viewModel.sign)
            + smallText(viewModel.currencySymbol)
            + largeText(viewModel.integer)
            + smallText(viewModel.decimalSeparator)
            + smallText(viewModel.fraction))
            .foregroundColor(viewModel.color)
    }

    public init(viewModel: AmountViewModel) {
        self.viewModel = viewModel
    }

    private func smallText(_ content: String) -> Text {
        Text(content).font(.system(.callout, design: .rounded))
    }

    private func largeText(_ content: String) -> Text {
        Text(content).font(.system(.largeTitle, design: .rounded))
    }
}

#if DEBUG
struct AmountViewPreviews: PreviewProvider {
    static var previews: some View {
        AmountView(viewModel: AmountViewModel(value: 12.34))
            .previewLayout(.sizeThatFits)
    }
}
#endif
