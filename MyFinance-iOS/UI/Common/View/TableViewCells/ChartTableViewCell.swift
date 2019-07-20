import Charts

class ChartTableViewCell: UITableViewCell {
    @IBOutlet var chart: LineChartView!

    private weak var viewModel: ChartCellModelForViewType?

    override func prepareForReuse() {
        super.prepareForReuse()

        viewModel?.viewDelegate = nil
        viewModel = nil
    }
}

extension ChartTableViewCell: TableViewCellForViewModelType {
    func update(viewModel: CellModelType) {
        guard let viewModel = viewModel as? ChartCellModelForViewType else { return }

        self.viewModel = viewModel
        self.viewModel?.viewDelegate = self

        update()
    }
}

extension ChartTableViewCell: ChartCellModelViewDelegate {
    func update() {
        guard let viewModel = viewModel else { return }

        chart.data = viewModel.data
        chart.xAxis.setLabelCount(viewModel.data.entryCount, force: true)

        chart.xAxis.valueFormatter = ChartCellModel.DateValueFormatter()
        chart.rightAxis.valueFormatter = ChartCellModel.CurrencyValueFormatter()

        chart.legend.enabled = false
        chart.chartDescription?.enabled = false
        chart.leftAxis.enabled = false
        chart.rightAxis.drawGridLinesEnabled = false
        chart.rightAxis.drawZeroLineEnabled = true
        chart.xAxis.gridLineDashPhase = 5
        chart.xAxis.gridLineDashLengths = [5]
        chart.xAxis.labelPosition = .bottom
        chart.rightAxis.setLabelCount(4, force: false)
        chart.xAxis.avoidFirstLastClippingEnabled = true
        chart.isUserInteractionEnabled = false
    }
}
