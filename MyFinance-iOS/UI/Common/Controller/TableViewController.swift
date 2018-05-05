struct TableViewUpdate {

    var insertSections: IndexSet = []
    var deleteSections: IndexSet = []
    var insertRows: [IndexPath] = []
    var deleteRows: [IndexPath] = []

}

protocol TableViewControllerType {

    func updateCells()
    func updateCells(tableViewUpdate: TableViewUpdate)

}

class TableViewController: NSObject {

    private let tableView: TableViewType
    private let viewModel: TableViewModelType
    private var isLoading = true

    init(tableView: TableViewType,
         cells: [TableViewCellType.Type],
         viewModel: TableViewModelType) {
        self.tableView = tableView
        self.viewModel = viewModel

        super.init()

        tableView.delegate = self
        tableView.dataSource = self

        for cell in cells {
            tableView.register(cell.nib, forCellReuseIdentifier: cell.reuseIdentifier)
        }
    }

    private func model(at indexPath: IndexPath) -> CellModelType {
        return viewModel.sections[indexPath.section].cellModels[indexPath.row].wrapped
    }

}

extension TableViewController: TableViewControllerType {

    func updateCells() {
        tableView.reloadData()
    }

    func updateCells(tableViewUpdate: TableViewUpdate) {
        tableView.beginUpdates()
        tableView.deleteSections(tableViewUpdate.deleteSections, with: .automatic)
        tableView.deleteRows(at: tableViewUpdate.deleteRows, with: .automatic)
        tableView.insertSections(tableViewUpdate.insertSections, with: .automatic)
        tableView.insertRows(at: tableViewUpdate.insertRows, with: .automatic)
        tableView.endUpdates()
    }

}

extension TableViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sections[section].cellModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellModel = model(at: indexPath)
        let tableViewCell = tableView
            .dequeueReusableCell(withIdentifier: type(of: cellModel).reuseIdentifier,
                                 for: indexPath)
        guard let cell = tableViewCell as? TableViewCellForViewModelType else { return UITableViewCell ()}
        cell.update(viewModel: cellModel)

        return tableViewCell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if isLoading {
            isLoading = false
            DispatchQueue.main.async {
                self.viewModel.didFinishLoadingTableView()
            }
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.sections[section].title
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.viewModel.didSelect(indexPath: indexPath)
        }
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return model(at: indexPath).canEdit
    }

    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCellEditingStyle,
                   forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        viewModel.didDelete(indexPath: indexPath)
    }

}

extension TableViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return type(of: model(at: indexPath)).rowHeight
    }

}
