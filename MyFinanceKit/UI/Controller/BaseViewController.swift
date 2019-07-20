open class BaseViewController: ViewController {
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        view.endEditing(true)
    }
}

extension BaseViewController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    public func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
}

extension BaseViewController: ViewControllerType {
    public var presented: ViewControllerType? {
        return presentedViewController as? ViewControllerType
    }

    public func present(viewController: ViewControllerType, animated: Bool) {
        guard let viewController = viewController as? BaseViewController else { return }
        present(viewController, animated: animated)
    }

    public func dismiss() -> Promise<Void> {
        return Promise { seal in
            dismiss(animated: true) {
                seal.fulfill(Void())
            }
        }
    }
}
