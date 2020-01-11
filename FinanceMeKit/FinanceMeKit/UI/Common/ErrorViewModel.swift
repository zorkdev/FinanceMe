// swiftlint:disable unused_declaration
final class ErrorViewModel: ObservableObject {
    @Published var error: Error? {
        didSet {
            icon = newIcon
        }
    }

    private var newIcon: String {
        ["🤔", "😳", "🙄", "😶", "😱"].randomElement()!
    }

    var icon: String?
    var description: String? { error?.localizedDescription }
}
