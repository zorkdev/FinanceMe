extension UITextField {

    @IBInspectable var showLeftLabel: Bool {
        get {
            return leftView is UILabel
        }
        set {
            if newValue {
                let label = UILabel()
                label.font = font
                leftView = label
                leftViewMode = .always
                label.sizeToFit()
            } else {
                leftView = nil
                leftViewMode = .never
            }
        }
    }

    @IBInspectable var leftLabelText: String? {
        get {
            return (leftView as? UILabel)?.text
        }
        set {
            (leftView as? UILabel)?.text = newValue
            (leftView as? UILabel)?.sizeToFit()
        }
    }

    @IBInspectable var leftLabelTextColor: UIColor? {
        get {
            return (leftView as? UILabel)?.textColor
        }
        set {
            (leftView as? UILabel)?.textColor = newValue
        }
    }

    func setLeftLabel(text: String, color: Color) {
        let label = (leftView as? UILabel) ?? UILabel()
        label.font = font
        label.text = text
        label.textColor = color
        leftView = label
        leftViewMode = .always
        label.sizeToFit()
    }

}
