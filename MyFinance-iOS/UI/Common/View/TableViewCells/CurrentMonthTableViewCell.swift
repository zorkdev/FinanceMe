class CurrentMonthTableViewCell: UITableViewCell {
    @IBOutlet var forecastLabel: UILabel!
    @IBOutlet var spendingLabel: UILabel!
    @IBOutlet var allowanceLabel: UILabel!

    private weak var viewModel: CurrentMonthCellModelForViewType?

    override func prepareForReuse() {
        super.prepareForReuse()

        viewModel?.viewDelegate = nil
        viewModel = nil
    }
}

extension CurrentMonthTableViewCell: TableViewCellForViewModelType {
    func update(viewModel: CellModelType) {
        guard let viewModel = viewModel as? CurrentMonthCellModelForViewType else { return }

        self.viewModel = viewModel
        self.viewModel?.viewDelegate = self

        update()
    }
}

extension CurrentMonthTableViewCell: CurrentMonthCellModelViewDelegate {
    func update() {
        guard let viewModel = viewModel else { return }

        forecastLabel.attributedText = viewModel.forecast
        spendingLabel.attributedText = viewModel.spending
        allowanceLabel.attributedText = viewModel.allowance
    }
}
