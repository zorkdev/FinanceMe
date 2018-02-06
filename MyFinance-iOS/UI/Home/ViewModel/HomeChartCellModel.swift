import Charts

struct HomeChartCellModel: HomeCellModelType {

    class DateValueFormatter: NSObject, IAxisValueFormatter {
        public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
            return Formatters.monthShort.string(from: Date(timeIntervalSince1970: value))
        }
    }

    class CurrencyValueFormatter: NSObject, IAxisValueFormatter {
        public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
            return Formatters.currencyNoFractions.string(from: NSNumber(value: value)) ?? ""
        }
    }

    static var rowHeight: CGFloat {
        switch UIDevice.current.userInterfaceIdiom {
        case .pad: return 350
        default: return 180
        }
    }

    let data: LineChartData

    init(endOfMonthSummaries: [EndOfMonthSummary]) {
        self.data = HomeChartCellModel.createChartData(from: endOfMonthSummaries)
    }

    private static func createChartData(from summaries: [EndOfMonthSummary]) -> LineChartData {
        var dataEntries = [ChartDataEntry]()

        for summary in summaries {
            dataEntries.append(ChartDataEntry(x: summary.created.timeIntervalSince1970,
                                              y: summary.balance))
        }

        let dataSet = LineChartDataSet(values: dataEntries, label: nil)
        dataSet.drawValuesEnabled = false
        dataSet.drawCirclesEnabled = false
        dataSet.drawFilledEnabled = true
        dataSet.lineWidth = 1
        dataSet.colors = [ColorPalette.secondary]
        dataSet.fillColor = ColorPalette.secondary.withAlphaComponent(0.5)

        return LineChartData(dataSet: dataSet)
    }

}

extension HomeChartTableViewCell {

    func set(homeChartCellModel: HomeChartCellModel) {
        chart.data = homeChartCellModel.data
        chart.legend.enabled = false
        chart.chartDescription?.enabled = false
        chart.leftAxis.enabled = false
        chart.rightAxis.drawGridLinesEnabled = false
        chart.rightAxis.drawZeroLineEnabled = true
        chart.xAxis.drawGridLinesEnabled = false
        chart.xAxis.labelPosition = .bottom
        chart.xAxis.valueFormatter = HomeChartCellModel.DateValueFormatter()
        chart.rightAxis.valueFormatter = HomeChartCellModel.CurrencyValueFormatter()
        chart.xAxis.setLabelCount(homeChartCellModel.data.entryCount, force: true)
        chart.xAxis.avoidFirstLastClippingEnabled = true
        chart.isUserInteractionEnabled = false
    }

}
