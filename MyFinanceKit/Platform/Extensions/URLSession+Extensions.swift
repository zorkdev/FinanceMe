extension URLSession: NetworkRequestable {

    func perform(request: URLRequest) -> Promise<Data> {
        return URLSession.shared.dataTask(with: request)
    }

}
