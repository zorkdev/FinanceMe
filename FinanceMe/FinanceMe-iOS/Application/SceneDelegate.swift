import UIKit
import SwiftUI
import FinanceMeKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    let appState: AppStateType = AppState()

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        #if DEBUG
        guard isUnitTesting == false else { return }
        #endif

        guard let windowScene = scene as? UIWindowScene else { return }
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = UIHostingController(rootView: TodayView(viewModel:
            TodayViewModel(businessLogic: appState.userBusinessLogic)))
        self.window = window
        window.makeKeyAndVisible()
    }
}
