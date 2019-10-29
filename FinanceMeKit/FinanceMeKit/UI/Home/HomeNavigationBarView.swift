import SwiftUI

public struct HomeNavigationBarView: View {
    private let appState: AppState
    @State private var isSettingsPresented = false
    @State private var isTransactionDetailPresented = false

    public var body: some View {
        HStack {
            Text("FinanceMe").font(.largeTitle).bold()
            Spacer()
            Button(action: {
                self.isSettingsPresented = true
            }, label: {
                #if os(macOS)
                Text("Settings")
                #else
                Image(systemName: "ellipsis.circle.fill").font(.title)
                #endif
            })
            .padding([.trailing], 4)
            .sheet(isPresented: self.$isSettingsPresented) {
                SettingsView(appState: self.appState)
            }
            Button(action: {
                self.isTransactionDetailPresented = true
            }, label: {
                #if os(macOS)
                Text("＋")
                #else
                Image(systemName: "plus.circle.fill").font(.title)
                #endif
            })
            .sheet(isPresented: self.$isTransactionDetailPresented) {
                TransactionDetailView(transaction: nil, appState: self.appState)
            }
        }
        .padding([.top, .leading, .trailing])
        .padding(.bottom, 8)
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
