struct HomeCellModel {

    static let negativeColor = UIColor.darkGray
    static let positiveColor = UIColor(red: 103/255.0,
                                       green: 184/255.0,
                                       blue: 82/255.0,
                                       alpha: 1)
    static let negativeBalanceColor = UIColor(red: 209/255.0,
                                              green: 69/255.0,
                                              blue: 58/255.0,
                                              alpha: 1)

    let title: String
    let detail: String
    let detailColor: UIColor

}

extension UITableViewCell {

    func set(homeCellModel: HomeCellModel) {
        textLabel?.text = homeCellModel.title
        detailTextLabel?.text = homeCellModel.detail
        detailTextLabel?.textColor = homeCellModel.detailColor
    }

}
