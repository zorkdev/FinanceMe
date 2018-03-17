class AppDelegate: UIResponder, UIApplicationDelegate {

    var appState: AppStateiOSType!
    var authViewModel: AuthViewModelType!

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]? = nil) -> Bool {
        if appState == nil { appState = AppStateiOS() }

        let loginViewModel = LoginViewModel(serviceProvider: appState)
        appState.navigator.createNavigationStack(viewModel: loginViewModel)

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
