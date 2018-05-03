class BasicTableViewCell: UITableViewCell {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var detailLabel: UILabel!

    private weak var viewModel: BasicCellModelForViewType?

    override func prepareForReuse() {
        super.prepareForReuse()

        viewModel?.viewDelegate = nil
        viewModel = nil
    }

}

extension BasicTableViewCell: TableViewCellForViewModelType {

    func update(viewModel: CellModelType) {
        guard let viewModel = viewModel as? BasicCellModelForViewType else { return }

        self.viewModel = viewModel
        self.viewModel?.viewDelegate = self

        update()
    }

}

extension BasicTableViewCell: BasicCellModelViewDelegate {

    func update() {
        guard let viewModel = viewModel else { return }

        titleLabel.text = viewModel.title
        detailLabel.text = viewModel.detail
        detailLabel.textColor = viewModel.detailColor
    }

}
