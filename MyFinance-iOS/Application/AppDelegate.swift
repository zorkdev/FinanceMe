class AppDelegate: UIResponder, UIApplicationDelegate {

    private var appState: AppStateiOS!
    private var authViewModel: AuthViewModelType!

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]? = nil) -> Bool {
        appState = AppStateiOS()

        let homeViewModel = HomeViewModel(serviceProvider: appState)
        appState.navigator.createNavigationStack(viewModel: homeViewModel)

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
