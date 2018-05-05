struct TableViewSection: Hashable {

    let id = UUID()
    let title: String?

    var cellModels: [CellModelWrapper]

    init(cellModels: [CellModelWrapper], title: String? = nil) {
        self.cellModels = cellModels
        self.title = title
    }

    var hashValue: Int {
        return title?.hashValue ?? id.hashValue
    }

    static func == (lhs: TableViewSection, rhs: TableViewSection) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }

}

protocol TableViewContainer: TableViewModelDelegate {

    var uiTableView: UITableView! { get }

}

extension TableViewContainer {

    var tableView: TableViewType { return uiTableView as TableViewType }

}

protocol TableViewModelDelegate: ViewModelDelegate {

    var tableView: TableViewType { get }

}

protocol TableViewModelType: class {

    var sections: [TableViewSection] { get }
    var tableViewController: TableViewControllerType? { get set }

    func didFinishLoadingTableView()
    func didSelect(indexPath: IndexPath)
    func didDelete(indexPath: IndexPath)

}

extension TableViewModelType {

    var isValid: Bool {
        return sections
            .flatMap({ $0.cellModels })
            .compactMap({ ($0.wrapped as? InputCellModelForViewModelType)?.isValid })
            .reduce(true) { $0 && $1 }
    }

    func didFinishLoadingTableView() {}
    func didSelect(indexPath: IndexPath) {}
    func didDelete(indexPath: IndexPath) {}

    func setup(tableView: TableViewType, cells: [TableViewCellType.Type]) {
        tableViewController = TableViewController(tableView: tableView,
                                                  cells: cells,
                                                  viewModel: self)
    }

    func updateSections(new: [TableViewSection], old: [TableViewSection]) {
        var tableViewUpdate = TableViewUpdate()

        let sectionsDiff = new.diff(other: old)
        tableViewUpdate.deleteSections = sectionsDiff.deletions
        tableViewUpdate.insertSections = sectionsDiff.insertions

        for index in sectionsDiff.unchanged {
            let newSection = new[index]
            guard let oldIndex = old.index(of: newSection) else { continue }
            let rowsDiff = newSection.cellModels.diff(other: old[oldIndex].cellModels)

            guard rowsDiff.deletions.isEmpty == false || rowsDiff.insertions.isEmpty == false else {
                continue
            }

            let deletionIndexPaths = rowsDiff.deletions.map({ IndexPath(row: $0, section: oldIndex) })
            let insertionIndexPaths = rowsDiff.insertions.map({ IndexPath(row: $0, section: index) })

            tableViewUpdate.deleteRows.append(contentsOf: deletionIndexPaths)
            tableViewUpdate.insertRows.append(contentsOf: insertionIndexPaths)
        }

        tableViewController?.updateCells(tableViewUpdate: tableViewUpdate)
    }

    func becomeFirstResponder() {
        (sections.first?.cellModels.first?.wrapped as? InputCellModelForViewModelType)?.becomeFirstResponder()
    }

}
