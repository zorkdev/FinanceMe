import SwiftUI
import FinanceMeKit

struct ContentView: View {
    var body: some View {
        Text(Content.content)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#if DEBUG
struct ContentViewPreviews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
