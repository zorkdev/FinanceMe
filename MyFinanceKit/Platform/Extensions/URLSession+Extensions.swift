extension URLSession: NetworkRequestable {

    func perform(request: URLRequest) -> Promise<(data: Data, response: URLResponse)> {
        return URLSession.shared.dataTask(.promise, with: request)
    }

}
