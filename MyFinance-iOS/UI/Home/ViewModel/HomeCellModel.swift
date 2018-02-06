protocol HomeCellModelType {

    static var rowHeight: CGFloat { get }

}

extension HomeCellModelType {

    static var rowHeight: CGFloat { return UITableViewAutomaticDimension }

}

struct HomeCellModel: HomeCellModelType {

    static let rowHeight: CGFloat = 60

    let title: String
    let detail: String
    let detailColor: UIColor

}

extension HomeTableViewCell {

    func set(homeCellModel: HomeCellModel) {
        textLabel?.text = homeCellModel.title
        detailTextLabel?.text = homeCellModel.detail
        detailTextLabel?.textColor = homeCellModel.detailColor
    }

}
