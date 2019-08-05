public protocol ServiceClient {
    associatedtype ServiceProvider
    var serviceProvider: ServiceProvider { get }
}
