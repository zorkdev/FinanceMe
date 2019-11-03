public class ErrorViewModel: ObservableObject {
    @Published public var error: Error? {
        didSet {
            icon = newIcon
        }
    }

    private var newIcon: String {
        ["🤔", "😳", "🙄", "😶", "😱"].randomElement()!
    }

    public var icon: String?
    public var description: String? { error?.localizedDescription }
}
