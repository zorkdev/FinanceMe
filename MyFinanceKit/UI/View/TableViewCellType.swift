public protocol TableViewCellType: class, StringRepresentable {

    static var reuseIdentifier: String { get }
    static var nib: UINib { get }

}

public extension TableViewCellType {

    static var reuseIdentifier: String {
        return instanceName
    }

    static var nib: UINib {
        let bundle = Bundle(for: self)
        return UINib(nibName: instanceName, bundle: bundle)
    }

}

public protocol TableViewCellForViewModelType {

    func update(viewModel: CellModelType)

}

extension UITableViewCell: TableViewCellType {}
