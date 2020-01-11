import SwiftUI
import FinanceMeKit

final class AppDelegate: UIResponder, UIApplicationDelegate {
    private let appState = AppState()
    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UIHostingController(rootView: RootView(appState: appState))
        window?.makeKeyAndVisible()
        return true
    }
}
