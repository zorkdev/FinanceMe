open class BaseViewController: UIViewController {

    public var appState: AppState!

    private struct Constants {
        static let keyboardToolbarDoneButtonTitle = "Done"
    }

    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        view.endEditing(true)
    }

}

extension BaseViewController: Dismissable {

    @IBAction public func dismiss(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
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

extension BaseViewController: ViewControllerType {}
