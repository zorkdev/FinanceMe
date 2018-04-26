protocol TableViewControllerType {

    func updateCells()

}

class TableViewController: NSObject {

    private let tableView: TableViewType
    private let viewModel: TableViewModelType

    init(tableView: TableViewType,
         cells: [TableViewCellType.Type],
         viewModel: TableViewModelType) {
        self.tableView = tableView
        self.viewModel = viewModel

        super.init()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = viewModel.rowHeight

        for cell in cells {
            tableView.register(cell.nib, forCellReuseIdentifier: cell.reuseIdentifier)
        }
    }

}

extension TableViewController: TableViewControllerType {

    func updateCells() {
        tableView.reloadData()
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
        let cellModel = viewModel.sections[indexPath.section].cellModels[indexPath.row]
        let tableViewCell = tableView
            .dequeueReusableCell(withIdentifier: type(of: cellModel).reuseIdentifier,
                                 for: indexPath)
        guard let cell = tableViewCell as? TableViewCellForViewModelType else { return UITableViewCell ()}
        cell.update(viewModel: cellModel)

        return tableViewCell
    }

}

extension TableViewController: UITableViewDelegate {}
