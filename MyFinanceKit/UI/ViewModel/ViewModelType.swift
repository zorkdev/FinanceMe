public protocol ViewModelDelegate: class {}

public protocol ViewModelType: class {

    func viewDidLoad()
    func inject(delegate: ViewModelDelegate)

}

public extension ViewModelType {

    func viewDidLoad() {}

}
