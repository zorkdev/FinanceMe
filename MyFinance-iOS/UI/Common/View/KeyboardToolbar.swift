class KeyboardToolbar {

    private struct Constants {
        static let doneButtonTitle = "Done"
    }

    private let doneAction: () -> Void

    let toolbar: UIToolbar

    init(doneAction: @escaping () -> Void) {
        self.doneAction = doneAction

        toolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.isTranslucent = true
        toolbar.barTintColor = ColorPalette.secondary
        toolbar.tintColor = Color.white

        let doneButton = UIBarButtonItem(title: Constants.doneButtonTitle,
                                         style: .done,
                                         target: self,
                                         action: #selector(doneTapped))

        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                          target: nil,
                                          action: nil)

        toolbar.setItems([spaceButton, doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        toolbar.sizeToFit()
    }

    @objc func doneTapped() {
        doneAction()
    }

}
