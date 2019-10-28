import SwiftUI

public struct HomeNavigationBarView: View {
    private let appState: AppState
    @State private var isDetailPresented = false

    public var body: some View {
        HStack {
            Text("FinanceMe").font(.largeTitle).bold()
            Spacer()
            Button(action: {
                self.isDetailPresented = true
            }, label: {
                #if os(macOS)
                Text("＋")
                #else
                Image(systemName: "plus.circle.fill").font(.title)
                #endif
            })
        }
        .padding([.top, .leading, .trailing])
        .padding(.bottom, 8)
        .sheet(isPresented: self.$isDetailPresented) {
            TransactionDetailView(transaction: nil, appState: self.appState)
        }
    }

    public init(appState: AppState) {
        self.appState = appState
    }
}

#if DEBUG
// swiftlint:disable unused_declaration
struct HomeNavigationBarViewPreviews: PreviewProvider {
    static var previews: some View {
        HomeNavigationBarView(appState: AppState.stub)
    }
}
#endif
