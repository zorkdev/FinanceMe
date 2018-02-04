@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private let authManager = AuthManager()

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]? = nil) -> Bool {
        authManager.authenticate()
        return true
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        authManager.authenticate()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        authManager.addOcclusion()
    }

}
