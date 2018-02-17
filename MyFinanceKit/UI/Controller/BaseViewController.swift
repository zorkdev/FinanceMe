open class BaseViewController: UIViewController {

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

#if os(iOS)
extension BaseViewController {

    public var keyBoardToolbar: UIToolbar {
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.barTintColor = ColorPalette.secondary
        toolBar.tintColor = Color.white
        let doneButton = UIBarButtonItem(title: Constants.keyboardToolbarDoneButtonTitle,
                                         style: .done,
                                         target: self,
                                         action: #selector(doneTapped))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                          target: nil,
                                          action: nil)
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()

        return toolBar
    }

    @objc open func doneTapped() {
        view.endEditing(true)
    }

}
#endif
