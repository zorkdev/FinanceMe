import UIKit

public extension UITableViewCell {

    static var nib: UINib {
        let bundle = Bundle(for: self)
        return UINib(nibName: string, bundle: bundle)
    }

}
