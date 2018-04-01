extension BaseViewController {

    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}

// MARK: - KeyboardToolbar

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
