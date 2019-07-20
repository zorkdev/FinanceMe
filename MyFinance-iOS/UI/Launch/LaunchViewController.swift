class LaunchViewController: BaseViewController {
    var viewModel: LaunchViewModelType!

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.viewDidAppear()
    }
}

extension LaunchViewController: ViewModelInjectable {
    func inject(viewModel: ViewModelType) {
        guard let viewModel = viewModel as? LaunchViewModelType else { return }
        self.viewModel = viewModel
    }
}
