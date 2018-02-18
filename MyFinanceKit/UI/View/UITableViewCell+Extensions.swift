public extension UITableViewCell {

    static var nib: UINib {
        let bundle = Bundle(for: self)
        return UINib(nibName: instanceName, bundle: bundle)
    }

}
