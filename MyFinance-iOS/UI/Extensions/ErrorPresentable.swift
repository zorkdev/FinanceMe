import SwiftMessages

public protocol ErrorPresentable where Self: UIViewController {

    func showError(message: String)

}

private struct ErrorBannerConstants {

    static let errorBannerTitle = "Uh-oh!"
    static let errorBannerIcons = ["🤔", "😳", "🙄", "😶", "😱"]
    static let errorBannerCloseImage = "close"

}

public extension ErrorPresentable {

    func showError(message: String) {
        let view = MessageView.viewFromNib(layout: .messageView)
        view.configureTheme(.error)
        view.configureDropShadow()

        let buttonImage = UIImage(named: ErrorBannerConstants.errorBannerCloseImage)
        let iconText = ErrorBannerConstants.errorBannerIcons.sm_random() ?? ""

        view.configureContent(title: ErrorBannerConstants.errorBannerTitle,
                              body: message,
                              iconImage: nil,
                              iconText: iconText,
                              buttonImage: buttonImage,
                              buttonTitle: nil,
                              buttonTapHandler: { _ in SwiftMessages.hide() })

        view.button?.backgroundColor = .clear
        view.button?.tintColor = .white

        var config = SwiftMessages.Config()
        config.preferredStatusBarStyle = .lightContent

        SwiftMessages.show(config: config, view: view)
    }

}

extension BaseViewController: ErrorPresentable {}
