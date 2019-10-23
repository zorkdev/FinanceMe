import SwiftUI

public struct AmountView: View {
    private let viewModel: AmountViewModel

    public var body: some View {
        (Text(viewModel.sign).font(.system(.callout, design: .rounded))
            + Text(viewModel.currencySymbol).font(.system(.callout, design: .rounded))
            + Text(viewModel.integer).font(.system(.largeTitle, design: .rounded))
            + Text(viewModel.decimalSeparator).font(.system(.callout, design: .rounded))
            + Text(viewModel.fraction).font(.system(.callout, design: .rounded)))
            .foregroundColor(viewModel.color)
    }

    public init(viewModel: AmountViewModel) {
        self.viewModel = viewModel
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
