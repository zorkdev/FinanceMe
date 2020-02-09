import SwiftUI

struct CurrentMonthView: View {
    private let currentMonth: CurrentMonthSummary

    var body: some View {
        HStack(spacing: .zero) {
            VStack(alignment: .leading) {
                AmountView(viewModel: AmountViewModel(value: currentMonth.forecast,
                                                      signs: [.plus, .minus]))
                    .frame(minWidth: .zero, maxWidth: .infinity, alignment: .leading)
                Text("FORECAST").font(.caption).foregroundColor(Color.secondary)
            }
            .accessibilityElement(children: .combine)
            VStack {
                AmountView(viewModel: AmountViewModel(value: currentMonth.spending,
                                                      signs: [.plus, .minus]))
                Text("SPENDING").font(.caption).foregroundColor(Color.secondary)
            }
            .accessibilityElement(children: .combine)
            VStack(alignment: .trailing) {
                AmountView(viewModel: AmountViewModel(value: currentMonth.allowance,
                                                      signs: [.plus, .minus]))
                    .frame(minWidth: .zero, maxWidth: .infinity, alignment: .trailing)
                Text("ALLOWANCE").font(.caption).foregroundColor(Color.secondary)
            }
            .accessibilityElement(children: .combine)
        }
        .padding([.top, .bottom])
    }

    init(currentMonth: CurrentMonthSummary) {
        self.currentMonth = currentMonth
    }
}

#if DEBUG
// swiftlint:disable unused_declaration
struct CurrentMonthViewPreviews: PreviewProvider {
    static var previews: some View {
        CurrentMonthView(currentMonth: CurrentMonthSummary(allowance: 100.22,
                                                           forecast: -123.42,
                                                           spending: -291.34))
            .previewLayout(.sizeThatFits)
    }
}
#endif
