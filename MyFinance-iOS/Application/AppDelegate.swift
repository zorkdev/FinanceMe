import LocalAuthentication

class AppDelegate: UIResponder, UIApplicationDelegate {

    private var authViewModel: AuthViewModelType!

    var window: UIWindow?

    let appState = AppStateiOS()

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]? = nil) -> Bool {

        let storyboard = UIStoryboard(name: UIViewController.storyboardId, bundle: nil)
        let initialViewController = storyboard.instantiateInitialViewController() as? BaseViewController
        initialViewController?.appState = appState
        window = UIWindow()
        window?.rootViewController = initialViewController

        if isTesting == false { window?.makeKeyAndVisible() }

        let authViewController = AuthViewController.instantiate()
        authViewModel = AuthViewModel(delegate: authViewController,
                                      window: window,
                                      viewController: authViewController,
                                      context: LAContext())
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
