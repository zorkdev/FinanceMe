protocol Dismissable {
    func dismissTapped()
}

extension Dismissable where Self: ServiceClient {
    func dismissTapped() {
        guard let serviceProvider = serviceProvider as? NavigatorProvider else { return }
        serviceProvider.navigator.dismiss()
    }
}
