class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    let appState = AppState()

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {

        let storyboard = UIStoryboard(name: UIViewController.storyboardId, bundle: nil)
        let initialViewController = storyboard.instantiateInitialViewController() as? BaseViewController
        window = UIWindow()
        window?.rootViewController = initialViewController
        window?.makeKeyAndVisible()

        return true
    }

}
