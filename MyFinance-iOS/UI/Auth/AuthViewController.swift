class AuthViewController: BaseViewController {

    @IBOutlet private weak var logoImageView: UIImageView!
    @IBOutlet private weak var tryAgainView: UIView!

    var viewModel: AuthViewModelType!

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    @IBAction func tryAgainButtonTapped(_ sender: UIButton) {
        viewModel.tryAgainButtonTapped()
    }

    private func animate(view: UIView, isHidden: Bool) {
        if isHidden {
            UIView.animate(withDuration: AuthDisplayModel.animationDuration, animations: {
                view.alpha = AuthDisplayModel.minAlpha
            }, completion: { _ in
                view.isHidden = true
            })
        } else {
            view.isHidden = false
            UIView.animate(withDuration: AuthDisplayModel.animationDuration) {
                view.alpha = AuthDisplayModel.maxAlpha
            }
        }
    }

}

extension AuthViewController: ViewModelInjectable {

    func inject(viewModel: ViewModelType) {
        guard let viewModel = viewModel as? AuthViewModelType else { return }
        self.viewModel = viewModel
    }

}

extension AuthViewController: AuthViewModelDelegate {

    func updateTryAgain(isHidden: Bool) {
        animate(view: tryAgainView, isHidden: isHidden)
    }

    func updateLogo(isHidden: Bool) {
        animate(view: logoImageView, isHidden: isHidden)
    }

}
