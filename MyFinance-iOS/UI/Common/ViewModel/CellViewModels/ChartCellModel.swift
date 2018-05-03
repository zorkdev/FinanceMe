import Charts

protocol ChartCellModelViewDelegate: class {

    func update()

}

protocol ChartCellModelForViewType: class {

    var viewDelegate: ChartCellModelViewDelegate? { get set }

    var data: LineChartData { get }

}

protocol ChartCellModelForViewModelType: CellModelType {

    func update(endOfMonthSummaries: [EndOfMonthSummary])

}

class ChartCellModel {

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

    weak var viewDelegate: ChartCellModelViewDelegate?

    var data: LineChartData

    init(endOfMonthSummaries: [EndOfMonthSummary]) {
        data = ChartCellModel.createChartData(from: endOfMonthSummaries)
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

extension ChartCellModel: ChartCellModelForViewType {}

extension ChartCellModel: ChartCellModelForViewModelType {

    static var reuseIdentifier: String {
        return ChartTableViewCell.reuseIdentifier
    }

    static var rowHeight: CGFloat {
        return UIDevice.current.userInterfaceIdiom == .phone ? 180 : 350
    }

    func update(endOfMonthSummaries: [EndOfMonthSummary]) {
        data = ChartCellModel.createChartData(from: endOfMonthSummaries)
        viewDelegate?.update()
    }

}
