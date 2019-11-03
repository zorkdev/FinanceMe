import Combine

extension Publisher {
    func handleResult(loadingState: LoadingState,
                      errorViewModel: ErrorViewModel,
                      cancellables: inout Set<AnyCancellable>,
                      onValue: ((Self.Output) -> Void)? = nil) {
        self
            .mapError { error -> Error in
                DispatchQueue.main.async {
                    errorViewModel.error = error
                }
                return error
            }.receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in loadingState.isLoading = false },
                  receiveValue: { onValue?($0) })
            .store(in: &cancellables)
    }
}
