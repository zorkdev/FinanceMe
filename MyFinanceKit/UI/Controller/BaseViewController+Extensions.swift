extension BaseViewController {

    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        registerForKeyboardNotifications()
    }

    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        deRegisterForKeyboardNotifications()
    }

}

// MARK: - Keyboard

extension BaseViewController {

    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardChanged),
                                               name: .UIKeyboardWillShow,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardChanged),
                                               name: .UIKeyboardWillHide,
                                               object: nil)
    }

    func deRegisterForKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self,
                                                  name: .UIKeyboardWillShow,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: .UIKeyboardWillHide,
                                                  object: nil)
    }

    @objc private func keyboardChanged(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
            let keyboardFrame = userInfo[UIKeyboardFrameEndUserInfoKey] as? CGRect,
            let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double,
            let curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? UInt else { return }

        let options = UIViewAnimationOptions(rawValue: curve)

        let newFrame = CGRect(x: view.frame.origin.x,
                              y: view.frame.origin.y,
                              width: view.frame.width,
                              height: keyboardFrame.minY - view.frame.origin.y)

        UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
            self.view.frame = newFrame
        }, completion: nil)
    }

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
