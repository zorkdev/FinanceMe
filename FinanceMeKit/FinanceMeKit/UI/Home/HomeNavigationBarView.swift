import SwiftUI

struct HomeNavigationBarView: View {
    private let appState: AppState
    @State private var isSettingsPresented = false
    @State private var isTransactionDetailPresented = false
    @ObservedObject private var loadingState: LoadingState
    @ObservedObject private var viewModel: HomeViewModel

    var body: some View {
        HStack {
            Text("FinanceMe").font(.largeTitle).bold()

            Spacer()

            Group {
                if loadingState.isLoading {
                    ActivityIndicatorView(style: .medium)
                } else {
                    Button(action: viewModel.onRefresh) {
                        #if os(macOS)
                        Text("Refresh")
                        #else
                        Image(systemName: "arrow.clockwise.circle.fill").font(.title)
                        #endif
                    }
                }
            }
            .padding([.trailing], 4)

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

    init(appState: AppState,
         loadingState: LoadingState,
         errorViewModel: ErrorViewModel) {
        self.appState = appState
        self.loadingState = loadingState
        self.viewModel = HomeViewModel(loadingState: loadingState,
                                       errorViewModel: errorViewModel,
                                       userBusinessLogic: appState.userBusinessLogic,
                                       transactionBusinessLogic: appState.transactionBusinessLogic,
                                       summaryBusinessLogic: appState.summaryBusinessLogic)
    }
}

#if DEBUG
// swiftlint:disable unused_declaration
struct HomeNavigationBarViewPreviews: PreviewProvider {
    static var previews: some View {
        HomeNavigationBarView(appState: AppState.stub,
                              loadingState: LoadingState(),
                              errorViewModel: ErrorViewModel())
            .previewLayout(.sizeThatFits)
    }
}
#endif
