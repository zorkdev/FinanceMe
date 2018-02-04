struct HomeCellModel {

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
