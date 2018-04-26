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

}

extension TableViewModelType {

    var rowHeight: CGFloat { return 60 }

}
