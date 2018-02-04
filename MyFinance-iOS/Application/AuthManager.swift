import PromiseKit
import LocalAuthentication

class AuthManager {

    private struct Constants {
        static let reason = "Please authenticate to unlock this app"
    }

    private var window: UIWindow?

    func authenticate() {
        addOcclusion()

        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthentication,
                                   localizedReason: Constants.reason) { [weak self] success, _ in
                DispatchQueue.main.async {
                    if success {
                        self?.removeOcclusion()
                    }
                }
            }
        }
    }

    func addOcclusion() {
        guard window == nil else {
            window?.isHidden = false
            return
        }

        let frame = window?.frame ?? CGRect(x: 0,
                                            y: 0,
                                            width: 10000,
                                            height: 10000)
        let occlusionView = UIView(frame: frame)
        let viewController = UIViewController()
        viewController.view = occlusionView
        occlusionView.backgroundColor = ColorPalette.primary
        window = UIWindow(frame: frame)
        window?.windowLevel = UIWindowLevelAlert
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
    }

    private func removeOcclusion() {
        window?.isHidden = true
    }

}
