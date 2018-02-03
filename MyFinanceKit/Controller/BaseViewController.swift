import UIKit

open class BaseViewController: UIViewController {}

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

}
