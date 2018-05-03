struct HomeCurrentMonthCellModel: HomeCellModelType {

    static let rowHeight: CGFloat = 90

    let allowance: String
    let forecast: String
    let spending: String

}

extension CurrentMonthTableViewCell {

    func set(homeCurrentMonthCellModel: HomeCurrentMonthCellModel) {
        allowanceLabel.attributedText = HomeCurrentMonthCellDisplayModel
            .amountAttributedString(from: homeCurrentMonthCellModel.allowance)
        forecastLabel.attributedText = HomeCurrentMonthCellDisplayModel
            .amountAttributedString(from: homeCurrentMonthCellModel.forecast)
        spendingLabel.attributedText = HomeCurrentMonthCellDisplayModel
            .amountAttributedString(from: homeCurrentMonthCellModel.spending)
    }

}
