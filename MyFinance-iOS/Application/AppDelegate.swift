@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    private var authViewModel: AuthViewModel!

    var window: UIWindow?

    let appState = AppStateiOS()

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]? = nil) -> Bool {
        (window?.rootViewController as? BaseViewController)?.appState = appState
        authViewModel = AuthViewModel(window: window)
        authViewModel.authenticate()
        return true
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        authViewModel.authenticate()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        authViewModel.addOcclusion()
    }

}
