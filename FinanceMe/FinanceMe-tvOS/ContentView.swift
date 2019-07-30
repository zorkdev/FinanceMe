import SwiftUI
import FinanceMeKit

struct ContentView: View {
    var body: some View {
        Text(AmountViewModel(value: Decimal(string: "10")!).string)
    }
}

#if DEBUG
struct ContentViewPreviews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
