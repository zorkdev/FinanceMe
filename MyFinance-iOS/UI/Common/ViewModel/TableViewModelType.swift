struct TableViewSection: Hashable {

    let id = UUID()

    var cellModels: [CellModelWrapper]

    init(cellModels: [CellModelWrapper]) {
        self.cellModels = cellModels
    }

    var hashValue: Int {
        return id.hashValue
    }

    static func == (lhs: TableViewSection, rhs: TableViewSection) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }

}

protocol TableViewModelDelegate: class {

    var tableView: TableViewType { get }

}

protocol TableViewModelType: ViewModelType {

    var sections: [TableViewSection] { get }
    var tableViewController: TableViewController? { get set }
    var isValid: Bool { get }

    func updateSections(new: [TableViewSection], old: [TableViewSection])

}

extension TableViewModelType {

    var isValid: Bool {
        return sections
            .flatMap({ $0.cellModels })
            .compactMap({ ($0.wrapped as? InputCellModelForViewModelType)?.isValid })
            .reduce(true) { $0 && $1 }
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

}
