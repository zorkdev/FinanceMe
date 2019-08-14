import XCTest
import Combine

public extension Publisher {
    func assertSuccess(_ testCase: XCTestCase, assertion: @escaping (Output) -> Void) {
        testCase.waitUntil { done in
            var cancellable: AnyCancellable?

            let action = {
                cancellable?.cancel()
                done()
            }

            cancellable = self.receive(on: DispatchQueue.main)
                .mapError { error -> Failure in
                    XCTFail("Should not have failed.")
                    action()
                    return error
                }
                .sink(receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        XCTFail(error.localizedDescription)
                        action()
                        return
                    }
                }, receiveValue: { output in
                    assertion(output)
                    action()
                })
        }
    }

    func assertFailure(_ testCase: XCTestCase, assertion: @escaping (Failure) -> Void) {
        testCase.waitUntil { done in
            var cancellable: AnyCancellable?

            let action = {
                cancellable?.cancel()
                done()
            }

            cancellable = self
                .mapError { error -> Failure in
                    assertion(error)
                    action()
                    return error
                }.receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { completion in
                    if case .finished = completion {
                        XCTFail("Should have failed.")
                        action()
                        return
                    }
                }, receiveValue: { _ in })
        }
    }
}
