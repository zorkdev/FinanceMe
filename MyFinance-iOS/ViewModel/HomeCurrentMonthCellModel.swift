struct HomeCurrentMonthCellModel: HomeCellModelType {

    static let rowHeight: CGFloat = 90

    let displayModel = HomeCurrentMonthCellDisplayModel()

    let allowance: String
    let forecast: String

}

extension HomeCurrentMonthTableViewCell {

    func set(homeCurrentMonthCellModel: HomeCurrentMonthCellModel) {
        allowanceLabel.attributedText = homeCurrentMonthCellModel
            .displayModel
            .amountAttributedString(from: homeCurrentMonthCellModel.allowance)
        forecastLabel.attributedText = homeCurrentMonthCellModel
            .displayModel
            .amountAttributedString(from: homeCurrentMonthCellModel.forecast)
    }

}
