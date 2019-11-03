import SwiftUI
import FinanceMeKit

// swiftlint:disable unused_declaration
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    private let appState = AppState()
    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        #if DEBUG
        guard isUnitTesting == false else { return }
        #endif

        guard let windowScene = scene as? UIWindowScene else { return }
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = UIHostingController(rootView: RootView(appState: appState)
            .listStyle(GroupedListStyle()))
        window?.makeKeyAndVisible()
    }
}
