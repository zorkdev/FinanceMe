struct TableViewSection {

    var cellModels: [CellModelType]

}

protocol TableViewModelDelegate: class {

    var tableView: TableViewType { get }

}

protocol TableViewModelType: ViewModelType {

    var sections: [TableViewSection] { get }
    var rowHeight: CGFloat { get }
    var tableViewController: TableViewController? { get set }
    var isValid: Bool { get }

}

extension TableViewModelType {

    var rowHeight: CGFloat { return 60 }

    var isValid: Bool {
        return sections
            .flatMap({ $0.cellModels })
            .compactMap({ ($0 as? InputCellModelForViewModelType)?.isValid })
            .reduce(true) { $0 && $1 }
    }

}
