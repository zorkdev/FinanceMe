struct HomeCellModel {

    let title: String
    let detail: String

}

extension UITableViewCell {

    func set(homeCellModel: HomeCellModel) {
        textLabel?.text = homeCellModel.title
        detailTextLabel?.text = homeCellModel.detail
    }

}
