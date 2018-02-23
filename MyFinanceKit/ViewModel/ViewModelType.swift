public protocol ViewModelType: AppStateConsumer {

    func viewDidLoad()

}

public extension ViewModelType {

    func viewDidLoad() {}

}
