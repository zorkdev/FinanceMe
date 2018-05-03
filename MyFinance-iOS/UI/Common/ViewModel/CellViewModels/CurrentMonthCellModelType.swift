protocol CurrentMonthCellModelViewDelegate: class {

    func update()

}

protocol CurrentMonthCellModelForViewType: class {

    var viewDelegate: CurrentMonthCellModelViewDelegate? { get set }

    var allowance: NSAttributedString { get }
    var forecast: NSAttributedString { get }
    var spending: NSAttributedString { get }

}

protocol CurrentMonthCellModelForViewModelType: CellModelType {

    func update(currentMonthSummary: CurrentMonthSummary)

}

class CurrentMonthCellModel {

    weak var viewDelegate: CurrentMonthCellModelViewDelegate?

    private var displayModel: CurrentMonthDisplayModel

    var forecast: NSAttributedString { return displayModel.forecast }
    var spending: NSAttributedString { return displayModel.spending }
    var allowance: NSAttributedString { return displayModel.allowance }

    init(currentMonthSummary: CurrentMonthSummary) {
        displayModel = CurrentMonthDisplayModel(currentMonthSummary: currentMonthSummary)
    }

}

extension CurrentMonthCellModel: CurrentMonthCellModelForViewType {}

extension CurrentMonthCellModel: CurrentMonthCellModelForViewModelType {

    static var reuseIdentifier: String {
        return CurrentMonthTableViewCell.reuseIdentifier
    }

    static var rowHeight: CGFloat { return 90 }

    func update(currentMonthSummary: CurrentMonthSummary) {
        displayModel = CurrentMonthDisplayModel(currentMonthSummary: currentMonthSummary)
        viewDelegate?.update()
    }

}
