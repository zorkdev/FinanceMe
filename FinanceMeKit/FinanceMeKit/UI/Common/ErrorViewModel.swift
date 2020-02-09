// swiftlint:disable unused_declaration
final class ErrorViewModel: ObservableObject {
    @Published var error: Error? {
        didSet {
            icon = newIcon
            isError = error != nil
        }
    }

    @Published var isError = false

    var icon: String?
    var description: String? { error?.localizedDescription }
}

private extension ErrorViewModel {
    var newIcon: String { ["🤔", "😳", "🙄", "😶", "😱"].randomElement()! }
}
