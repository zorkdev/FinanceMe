protocol BasicCellModelViewDelegate: class {

    func update()

}

protocol BasicCellModelForViewType: class {

    var viewDelegate: BasicCellModelViewDelegate? { get set }

    var title: String { get }
    var detail: String { get }
    var detailColor: Color { get }

}

protocol BasicCellModelForViewModelType: CellModelType {}

extension BasicCellModelForViewModelType {

    static var reuseIdentifier: String {
        return BasicTableViewCell.reuseIdentifier
    }

}
