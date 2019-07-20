public protocol ViewModelDelegate: AnyObject {}

public protocol ViewModelType: AnyObject {
    func viewDidLoad()
    func inject(delegate: ViewModelDelegate)
}

public extension ViewModelType {
    func viewDidLoad() {}
}
