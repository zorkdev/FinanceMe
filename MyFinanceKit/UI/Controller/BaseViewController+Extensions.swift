public protocol KeyboardManageable {}

extension BaseViewController {

    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if self is KeyboardManageable { registerForKeyboardNotifications() }
    }

    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        if self is KeyboardManageable { deRegisterForKeyboardNotifications() }
    }

}

// MARK: - Keyboard

extension BaseViewController {

    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardChanged),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardChanged),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }

    func deRegisterForKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: nil)
    }

    @objc private func keyboardChanged(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
            let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
            let curve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else { return }

        let options = UIView.AnimationOptions(rawValue: curve)

        let newFrame = CGRect(x: view.frame.origin.x,
                              y: view.frame.origin.y,
                              width: view.frame.width,
                              height: keyboardFrame.minY - view.frame.origin.y)

        UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
            self.view.frame = newFrame
        }, completion: nil)
    }

}
