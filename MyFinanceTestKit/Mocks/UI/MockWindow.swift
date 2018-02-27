class MockWindow: WindowType {

    var frame: CGRect = CGRect.zero
    var windowLevel: UIWindowLevel = UIWindowLevelNormal
    var isHidden: Bool = false
    var baseViewController: ViewControllerType?

    init(frame: CGRect = CGRect.zero) {
        self.frame = frame
    }

    func endEditing(_ force: Bool) -> Bool {
        return true
    }

    func makeKeyAndVisible() {

    }

    func createWindow(frame: CGRect) -> WindowType {
        return MockWindow(frame: frame)
    }

}
