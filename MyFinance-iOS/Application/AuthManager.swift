import PromiseKit
import LocalAuthentication

class AuthManager {

    private struct Constants {
        static let reason = "Please authenticate to unlock this app"
        static let tryAgainButtonTitle = "Try again"
        static let tryAgainButtonFont = UIFont.systemFont(ofSize: 26, weight: .bold)
    }

    private var window: UIWindow?
    private var occlusionView: UIView?
    private var tryAgainButton: UIButton?

    @objc func authenticate() {
        addOcclusion()

        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthentication,
                                   localizedReason: Constants.reason) { [weak self] success, _ in
                DispatchQueue.main.async {
                    if success {
                        self?.removeOcclusion()
                    } else {
                        self?.addTryAgainButton()
                    }
                }
            }
        }
    }

    func addTryAgainButton() {
        guard tryAgainButton == nil,
            let frame = occlusionView?.frame else { return }

        tryAgainButton = UIButton(frame: frame)
        tryAgainButton?.addTarget(self,
                                  action: #selector(authenticate),
                                  for: .touchUpInside)
        tryAgainButton?.setTitle(Constants.tryAgainButtonTitle, for: .normal)
        tryAgainButton?.titleLabel?.font = Constants.tryAgainButtonFont
        guard let tryAgainButton = tryAgainButton else { fatalError() }
        occlusionView?.addSubview(tryAgainButton)
    }

    func removeTryAgainButton() {
        tryAgainButton?.removeFromSuperview()
        tryAgainButton = nil
    }

    func addOcclusion() {
        guard window == nil else {
            window?.isHidden = false
            return
        }

        guard let frame = UIApplication.shared.delegate?.window??.frame else { fatalError() }

        occlusionView = UIView(frame: frame)
        let viewController = UIViewController()
        viewController.view = occlusionView
        occlusionView?.backgroundColor = ColorPalette.primary
        window = UIWindow(frame: frame)
        window?.windowLevel = UIWindowLevelAlert
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
    }

    private func removeOcclusion() {
        removeTryAgainButton()
        window?.isHidden = true
    }

}
