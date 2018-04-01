class AppDelegate: UIResponder, UIApplicationDelegate {

    var appState: AppStateiOSType!
    var authViewModel: AuthViewModelType!

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]? = nil) -> Bool {
        if appState == nil { appState = AppStateiOS() }

        appState.navigator.createNavigationStack()

        if authViewModel == nil { authViewModel = AuthViewModel(serviceProvider: appState) }
        appState.navigator.createAuthStack(viewModel: authViewModel)
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
