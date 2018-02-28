class MockWindow: WindowType {

    var frame: CGRect = CGRect.zero
    var windowLevel: UIWindowLevel = UIWindowLevelNormal
    var isHidden: Bool = false
    var baseViewController: ViewControllerType?

    var lastEndEditingValue: Bool?
    var lastCreateWindow: MockWindow?
    var didCallMakeKeyAndVisible = false

    init(frame: CGRect = CGRect.zero) {
        self.frame = frame
    }

    func endEditing(_ force: Bool) -> Bool {
        lastEndEditingValue = force
        return true
    }

    func makeKeyAndVisible() {
        didCallMakeKeyAndVisible = true
    }

    func createWindow(frame: CGRect) -> WindowType {
        let window = MockWindow(frame: frame)
        lastCreateWindow = window
        return window
    }

}
