open class BaseViewController: ViewController {

    struct Constants {
        static let keyboardToolbarDoneButtonTitle = "Done"
    }

    open override func viewWillDisappear(_ animated: Bool) {
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

    public func present(viewController: ViewControllerType) {
        guard let viewController = viewController as? BaseViewController else { return }
        present(viewController, animated: true)
    }

    public func dismiss() -> Promise<Void> {
        return Promise { seal in
            dismiss(animated: true) {
                seal.fulfill(Void())
            }
        }
    }

}
