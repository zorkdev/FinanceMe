import SwiftUI
import FinanceMeKit

struct ContentView: View {
    @EnvironmentObject private var appState: AppState

    var body: some View {
        VStack {
            VerticalTodayView(viewModel: TodayViewModel(businessLogic: appState.userBusinessLogic))
        }
    }
}

#if DEBUG
struct ContentViewPreviews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(AppState.stub)
    }
}
#endif
