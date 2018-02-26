import SwiftMessages
import NVActivityIndicatorView

public protocol MessagePresentable {

    func showError(message: String)
    func showSpinner()
    func hideSpinner()

}

private struct MessageConstants {

    static let errorBannerTitle = "Uh-oh!"
    static let errorBannerIcons = ["🤔", "😳", "🙄", "😶", "😱"]
    static let errorBannerCloseImage = "close"

    static let successBannerIcon = "😇"

    static let spinnerTitle = "Doing some magic... 😬"

}

public extension MessagePresentable {

    func showError(message: String) {
        let view = MessageView.viewFromNib(layout: .messageView)
        view.configureTheme(.error)
        view.configureDropShadow()

        let buttonImage = UIImage(named: MessageConstants.errorBannerCloseImage)
        let iconText = MessageConstants.errorBannerIcons.sm_random() ?? ""

        view.configureContent(title: MessageConstants.errorBannerTitle,
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

    func showSuccess(message: String) {
        let view = MessageView.viewFromNib(layout: .centeredView)
        view.configureTheme(.success)
        view.configureDropShadow()

        let iconText = MessageConstants.successBannerIcon

        view.configureContent(title: message,
                              body: "",
                              iconText: iconText)

        view.button?.isHidden = true
        view.bodyLabel?.isHidden = true

        var config = SwiftMessages.Config()
        config.preferredStatusBarStyle = .lightContent
        config.presentationStyle = .center
        config.duration = .seconds(seconds: 1)

        SwiftMessages.show(config: config, view: view)
    }

    func showSpinner() {
        let data = ActivityData(size: nil,
                                message: MessageConstants.spinnerTitle,
                                messageFont: nil,
                                messageSpacing: nil,
                                type: .pacman,
                                color: nil,
                                padding: nil,
                                displayTimeThreshold: nil,
                                minimumDisplayTime: nil,
                                backgroundColor: nil,
                                textColor: nil)

        NVActivityIndicatorPresenter.sharedInstance.startAnimating(data)
    }

    func hideSpinner() {
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
    }

}

extension BaseViewController: MessagePresentable {}
